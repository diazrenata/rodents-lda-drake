hostname <- Sys.getenv("HOSTNAME")

print(hostname)

nodename <- Sys.info()["nodename"]

print(nodename)

if(grepl("ufhpc", nodename)) {
  print("I know I am on SLURM!")
}