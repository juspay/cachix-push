# Extract store paths along with their name from omnix CI json. Fail if the results encompass more than one system.
#
# Arguments:
# - $name: the subflake to use
# - $prefix: the prefix to use (usually git branch)

if (.systems | length) != 1 
    then error("systems array must have exactly 1 element") 
    else .systems[0] as $sys 
        | .result.[$name].build.byName 
        | with_entries(.key = "\($prefix)-\($sys)-" + .key) 
end