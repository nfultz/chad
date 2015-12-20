# Helper for git commit
gitCommit <- function(file.name) {
  systemf("git add '%s'", file.name)
  systemf("git commit -s -m 'AAG %s' -- '%s'", file.name, file.name)
}