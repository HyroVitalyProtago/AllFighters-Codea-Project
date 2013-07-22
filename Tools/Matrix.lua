-- Matrix
------------------------------------ Utils for matrix ------------------------------------
-- @Author : Andrew_Stacey
-- 

function applymatrix4(v,m)
    return vec4(
        m[1]*v[1] + m[5]*v[2] + m[09]*v[3] + m[13]*v[4],
        m[2]*v[1] + m[6]*v[2] + m[10]*v[3] + m[14]*v[4],
        m[3]*v[1] + m[7]*v[2] + m[11]*v[3] + m[15]*v[4],
        m[4]*v[1] + m[8]*v[2] + m[12]*v[3] + m[16]*v[4]
    )
end

-- Apply a 3-matrix to a 3-vector
function applymatrix3(v,m)
    return v.x * m[1] + v.y * m[2] + v.z * m[3]
end

-- Compute the cofactor matrix of a 3x3 matrix, entries
-- hard-coded for efficiency.
-- The cofactor differs from the inverse by a scale factor, but
-- as our matrices are only well-defined up to scale, this
-- doen't matter.
function cofactor3(m)
    return {
        vec3(
            m[2].y * m[3].z - m[3].y * m[2].z,
            m[3].y * m[1].z - m[1].y * m[3].z,
            m[1].y * m[2].z - m[2].y * m[1].z
        ),
        vec3(
            m[2].z * m[3].x - m[3].z * m[2].x,
            m[3].z * m[1].x - m[1].z * m[3].x,
            m[1].z * m[2].x - m[2].z * m[1].x
        ),
        vec3(
            m[2].x * m[3].y - m[3].x * m[2].y,
            m[3].x * m[1].y - m[1].x * m[3].y,
            m[1].x * m[2].y - m[2].x * m[1].y
        )
    }
end

-- Given a plane in space, this computes the transformation
-- matrix from that plane to the screen
function __planetoscreen(o,u,v,A)
    A = A or modelMatrix() * viewMatrix() * projectionMatrix()
    o = o or vec3(0,0,0)
    u = u or vec3(1,0,0)
    v = v or vec3(0,1,0)
    -- promote to 4-vectors
    o = vec4(o.x,o.y,o.z,1)
    u = vec4(u.x,u.y,u.z,0)
    v = vec4(v.x,v.y,v.z,0)
    local oA, uA, vA
    oA = applymatrix4(o,A)
    uA = applymatrix4(u,A)
    vA = applymatrix4(v,A)
    return { vec3(uA[1], uA[2], uA[4]),
             vec3(vA[1], vA[2], vA[4]),
             vec3(oA[1], oA[2], oA[4])}
end

-- Given a plane in space, this computes the transformation
-- matrix from the screen to that plane
function screentoplane(t,o,u,v,A)
    A = A or modelMatrix() * viewMatrix() * projectionMatrix()
    o = o or vec3(0,0,0)
    u = u or vec3(1,0,0)
    v = v or vec3(0,1,0)
    t = t or CurrentTouch
    local m = __planetoscreen(o,u,v,A)
    m = cofactor3(m)
    local ndc = vec3((t.x/WIDTH - .5)*2,(t.y/HEIGHT - .5)*2,1)
    local a
    a = applymatrix3(ndc,m)
    if (a[3] == 0) then return end
    a = vec2(a[1], a[2])/a[3]
    return o + a.x*u + a.y*v
end
------------------------------------------------------------------------