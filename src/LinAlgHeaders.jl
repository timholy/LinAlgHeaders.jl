module LinAlgHeaders

using Clang

include("wrap_utils.jl")
const topdir = splitdir(splitdir(JULIA_HOME)[1])[1]
const depsdir = joinpath(topdir, "deps")
const basedir = joinpath(topdir, "base")

### CHOLMOD
function cholmod()
    cmdir = finddir(depsdir, ("SuiteSparse", "CHOLMOD"))
    includedir = "Include"
    headers = ["cholmod_core.h"]
    headers = [joinpath(depsdir, cmdir, includedir, h) for h in headers]
    outdir = joinpath(basedir, "sparse", "gen")
    isdir(outdir) || mkdir(outdir)
    context=wrap_c.init(output_dir=outdir,
                        output_file="cholmod_decls.jl",
                        common_file="cholmod_defs.jl",
                        header_library=x->:libcholmod,
                        headers = headers,
                        clang_diagnostics=true,
                        header_wrapped=(x,y)->true)

    context.options.wrap_structs = true
#    context.options.immutable_structs = true
    run(context)
end

end # module
