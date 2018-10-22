module TrueSeabed

using AliasedSeabed

export blackwell_tsbmask

function blackwell_tsbmask(Sv, ntheta, nphi; Ttheta=702, Tphi=282, dtheta=28, dphi=52, minSv=-50)

    # Run ASB with a high threshold
    asb = asbmask(Sv, ntheta, nphi, Ttheta=Ttheta, Tphi=Tphi, dtheta=dtheta, dphi=dphi, minSv=minSv)
    c = copy(asb)

    # Label areas of ASB
    labels = label_components(asb)
    for i in 1:maximum(labels)
        b = (labels .== i)
        s = median(Sv[b])
        # Wipe out areas below the treshold
        if s < minSv
            c[b] .= false
        end
    end

    # Add the region below the seabed
    m,n = size(c)
    for j in 1:n
        for i in 1:m
            if c[i,j]
                c[i:end,j] .= true
                break
            end
        end
    end

    return c
end

end # module
