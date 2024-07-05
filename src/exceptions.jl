struct UndefinedMethod <: Exception end

showerror(io::IO, ::UndefinedMethod) =
    print(io, "Required method undefined.")
