print "Creating directories..."

let paths_to_create = [$"($env.HOME)/Work", $"($env.HOME)/Projects"]
mkdir --verbose ...$paths_to_create