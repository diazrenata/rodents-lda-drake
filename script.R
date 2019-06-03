library(drake)
library(dplyr)
library(portalr)

pipeline <- drake_plan(

all_portal_rodents = portalr::summarise_rodent_data(path = "repo", clean = TRUE, level = "Treatment", type = "Rodents", plots = "all", unknowns = FALSE, shape = "crosstab", time = "newmoon", output = "abundance"),

control_rodents = all_portal_rodents %>%
  dplyr::filter(treatment == "control"),

control_for_lda = list(abundance = dplyr::select(control_rodents, -newmoonnumber, -treatment), covariates = dplyr::select(control_rodents, newmoonnumber), metadata = list(timename = "newmoonnumber")),

exclosure_rodents = all_portal_rodents %>%
  dplyr::filter(treatment == "exclosure"),

exclosure_for_lda = list(abundance = dplyr::select(exclosure_rodents, -newmoonnumber, -treatment), covariates = dplyr::select(exclosure_rodents, newmoonnumber), metadata = list(timename = "newmoonnumber")),

control_lda = LDATS::LDA_set(control_for_lda$abundance, topics = c(2:3), nseeds = 4),

controls = LDATS::TS_controls_list(timename = "newmoonnumber"),

control_ts_on_lda = LDATS::TS_on_LDA(control_lda, document_covariate_table = control_for_lda$covariates, formulas = ~1, nchangepoints = c(0:3), weights = NULL, control = controls),

control_selected = LDATS::select_TS(control_ts_on_lda),

exclosure_lda = LDATS::LDA_set(exclosure_for_lda$abundance, topics = c(2:3), nseeds = 4),

exclosure_ts_on_lda = LDATS::TS_on_LDA(exclosure_lda, document_covariate_table = exclosure_for_lda$covariates, formulas = ~1, nchangepoints = c(0:3), weights = NULL, control = controls),

exclosure_selected = LDATS::select_TS(exclosure_ts_on_lda)
)

db <- DBI::dbConnect(RSQLite::SQLite(), here::here("drake", "drake-cache.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)

library(future.batchtools)
## Run the pipeline parallelized for HiPerGator
future::plan(batchtools_slurm, template = "slurm_batchtools.tmpl")

make(pipeline,
     force = TRUE,
     cache = cache,
     cache_log_file = here::here("drake", "cache_log.txt"),
     verbose = 2,
     parallelism = "future",
     jobs = 2,
     caching = "master") # Important for DBI caches!