using BinaryBuilder, SHA


version_dict = Dict()
for f in readdir("products/")
    if !endswith(f, ".tar.gz")
        continue
    end
    @info("Hashing $f....")
    name, version, platkey = extract_name_version_platform_key(f)

    if !(version in keys(version_dict))
        version_dict[version] = Dict()
    end
    hash = open(joinpath("products", f)) do f
        bytes2hex(sha256(f))
    end
    version_dict[version][triplet(platkey)] = (f => hash)
end

name = "GCC"
tag_name = BinaryBuilder.get_tag_name()
bin_path = "https://github.com/staticfloat/GCCBuilder/releases/download/$(tag)"
products = [ExecutableProduct(Prefix("."), "gcc", :gcc)]
for version in keys(version_dict)
    print_buildjl(pwd(), name, version, products, version_dict[version], bin_path)
end

@info("Uploading to GitHub....")
run(`ghr -replace $(tag_name) products/`)
