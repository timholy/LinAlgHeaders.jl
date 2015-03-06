@doc """
`path = finddir(depname)` find the (versioned) path for a particular
dependency specified by `depname`.  `depname` might be a string, e.g.,
`arpack-ng`, or a tuple representing a subdirectory, e.g.,
`("SuiteSparse","CHOLMOD")`. On output, `path` is the full pathname to
the most recent version of the dependency.
""" ->
finddir(depsdir, depname::Tuple) = joinpath(finddir(depsdir, depname[1]), depname[2:end]...)

function finddir(depsdir, topdir::AbstractString)
    depsnames = readdir(depsdir)
    names = filter(x->isdir(joinpath(depsdir, x)), filter(x->startswith(x, topdir), depsnames))
    versions = map(x->Base.VersionNumber(x[length(topdir)+2:end]), names)
    ind = indmax(versions)
    names[ind]
end
