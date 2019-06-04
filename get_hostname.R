hostname <- Sys.getenv("HOSTNAME")

print(hostname)

info <- Sys.info()

nodename <- info["nodename"]

print(nodename)

if(grepl("ufhpc", nodename)) {
  print("I know I am on SLURM!")
}