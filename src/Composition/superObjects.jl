mutable struct SuperObjCollision
    superObj::Array{Object3D,1}
    function SuperObjCollision()
        new(Array{Object3D,1}())
    end
end

mutable struct SuperObjMass
    superObj::Array{Object3D,1}
    function SuperObjMass()
        new(Array{Object3D,1}())
    end
end

mutable struct SuperObjForce
    superObj::Array{Object3D,1}
    function SuperObjForce()
        new(Array{Object3D,1}())
    end
end

mutable struct SuperObjVisu
    superObj::Array{Object3D,1}
    function SuperObjVisu()
        new(Array{Object3D,1}())
    end
end

mutable struct SuperObjsRow
    superObjCollision::SuperObjCollision
    superObjMass::SuperObjMass
    superObjForce::SuperObjForce
    superObjVisu::SuperObjVisu
    noCPair::Array{Int64,1}
    function SuperObjsRow()
        new(SuperObjCollision(), SuperObjMass(), SuperObjForce(), SuperObjVisu(), Array{Int64,1}())
    end
end
