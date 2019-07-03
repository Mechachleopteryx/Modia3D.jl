module contactForceLaw_rollingBall_2balls

using Modia3D
using Modia3D.StaticArrays
import Modia3D.ModiaMath


vmatGraphics = Modia3D.Material(color="LightBlue" , transparency=0.5)    # material of Graphics
vmatSolids = Modia3D.Material(color="Red" , transparency=0.5)         # material of solids
vmatTable = Modia3D.Material(color="Green", transparency=0.5)         # material of table

cmatTable = Modia3D.ElasticContactMaterial2("BilliardTable")
cmatBall = Modia3D.ElasticContactMaterial2("BilliardBall")

LxGround = 2.0
LyBox = 0.5
LzBox = 0.1
diameter = 0.06
@assembly Table(world) begin
  withBox = Modia3D.Solid(Modia3D.SolidBox(LxGround, LyBox, LzBox) , "DryWood", vmatTable; contactMaterial = cmatTable)
  box1 = Modia3D.Object3D(world, withBox, r=[1.0, 0.0, -LzBox/2], fixed=true)
end

@assembly TwoRollingBalls() begin
  world = Modia3D.Object3D(visualizeFrame=false)
  table = Table(world)
  ball1 = Modia3D.Object3D(world, Modia3D.Solid(Modia3D.SolidSphere(diameter), "BilliardBall", vmatSolids ; contactMaterial = cmatBall), fixed = false, r=[0.2, 0.0, diameter/2], v_start=[3.0, 0.0, 0.0] )
#  ball2 = Modia3D.Object3D(world, Modia3D.Solid(Modia3D.SolidSphere(diameter), "BilliardBall", vmatSolids ; contactMaterial = cmatBall), fixed = false, r=[1.5, 0.0, diameter/2])
end


gravField = Modia3D.UniformGravityField(g=9.81, n=[0,0,-1])
bill = TwoRollingBalls(sceneOptions=Modia3D.SceneOptions(gravityField=gravField,visualizeFrames=true, defaultFrameLength=0.2,nz_max = 100, enableContactDetection=true, visualizeContactPoints=false, visualizeSupportPoints=false))

#Modia3D.visualizeAssembly!( bill )

model = Modia3D.SimulationModel( bill )
#ModiaMath.print_ModelVariables(model)
result = ModiaMath.simulate!(model; stopTime=1.75, tolerance=1e-8,interval=0.001, log=false)

#=
ModiaMath.plot(result, [("ball1.r[1]"),
                        ("ball1.r[3]"),
                        ("ball1.v[1]"),
                        ("ball1.w[2]")])
=#

ModiaMath.plot(result, [("ball1.r[1]", "ball2.r[1]"),
                        ("ball1.v[1]", "ball2.v[1]"),
                        ("ball1.w[2]", "ball2.w[2]")])

#                        ("ball1.r[3]", "ball2.r[3]"),

#=

ModiaMath.plot(result, [("ball1.r[3]", "ball2.r[3]"),
                        ("ball1.v[1]", "ball2.v[1]"),
                        ("ball1.v[3]", "ball2.v[3]"),
                        ("ball1.w[2]", "ball2.w[2]"),
                        ("ball1.w[1]", "ball2.w[1]")])
=#


ball_r = result.series["ball1.r"][:,1]
t      = result.series["time"]
l_t    = length(t)

dist = ( ball_r[2] - ball_r[1] ) / (t[2] - t[1] )
distEnd = ( ball_r[l_t] - ball_r[l_t - 1] ) / (t[l_t] - t[l_t-1] )

println("dist = ", dist)
println("distEnd = ", distEnd)

println("... success of contactForceLaw_rollingBall_2balls.jl!")
end
