library(drake)
library(dplyr)
library(MATSS)
library(LDATS)

pipeline <- drake_plan(
  
  portal_data = MATSS::get_portal_rodents(),
  
  portal_lda =  LDATS::LDA_set(document_term_table = portal_data$abundance,
                              topics = c(2:6),
                              nseeds = 10,
                              control = list(quiet = TRUE)),
  
  
  
  portal_lda_selected = LDATS::select_LDA(portal_lda)
  
)


db <- DBI::dbConnect(RSQLite::SQLite(), here::here("drake", "drake-cache.sqlite"))
cache <- storr::storr_dbi("datatable", "keystable", db)


## View the graph of the plan
if (interactive())
{
  config <- drake_config(pipeline, cache = cache)
  sankey_drake_graph(config, build_times = "none")  # requires "networkD3" package
  vis_drake_graph(config, build_times = "none")     # requires "visNetwork" package
}

# 
# library(future.batchtools)
# ## Run the pipeline parallelized for HiPerGator
# future::plan(batchtools_slurm, template = "slurm_batchtools.tmpl")
# 
# make(pipeline,
#      force = TRUE,
#      cache = cache,
#      cache_log_file = here::here("drake", "cache_log.txt"),
#      verbose = 2,
#      parallelism = "future",
#      jobs = 2,
#      caching = "master") # Important for DBI caches!

make(pipeline, cache = cache, cache_log_file = here::here("drake", "cache_log.txt"))
