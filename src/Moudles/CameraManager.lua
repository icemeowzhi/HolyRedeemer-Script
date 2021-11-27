local CameraManager = {}

local CurrentCamera = nil
local CurrentCameraEffect = nil

function CameraManager:new()
	local obj = {}
	self.__index = self
	setmetatable(obj,self)
	return obj
end
--继承
function CameraManager:subClass(className)
	_G[className] = {}
	local obj = _G[className]
	obj.base = self
	self.__index = self
	setmetatable(obj,self)
end

--从第二个参数开始赋值 第一个为自身 self 
--调用方法：XX:ColorGrading(world.CurrentCamera,Vector3(100,100,100),Vector3(100,100,100),Vector3(100,100,100),10,10)
--色调映射
--[[
GradingMethod 分级方法（选择使用RGB还是LUT）
R/G/B 红绿蓝的调色Channel
LUT 查找表引用，拖入引用的查找表资源
LUT Intensity LUT缩放强度系数，0表示无映射，1表示完全映射
]]
function CameraManager:ColorGrading(p1,_R,_G,_B,Saturation,Contrast)
	local CameraEffect = world:CreateInstance('ColorGrading','ColorGrading',self.CurrentCamera)
	self.CurrentCameraEffect = CameraEffect
	CameraEffect.R = _R
	CameraEffect.G = _G
	CameraEffect.B = _B
	CameraEffect.Saturation = Saturation
	CameraEffect.Contrast = Contrast
end

--调用方法：XX:Vignette(world.CurrentCamera,Color(255,255,255,255),0.5)
--四角晕影滤镜
function CameraManager:Vignette(p1,Tcolor,Tintensity)
	local CameraEffect = world:CreateObject('Vignette','Vignette',self.CurrentCamera)
	self.CurrentCameraEffect = CameraEffect
	CameraEffect.Color = Tcolor
	CameraEffect.Intensity = Tintensity

end

--调用方法：XX:GaussionBlur(world.CurrentCamera,0.5)
--高斯模糊
function CameraManager:GaussionBlur(p1,Tintensity)
	local CameraEffect = world:CreateObject('GaussionBlur','GaussionBlur',self.CurrentCamera)
	self.CurrentCameraEffect = CameraEffect
	CameraEffect.Intensity = Tintensity

end

--颗粒效果
--XX:Grain(world.CurrentCamera,1,1,0.5)
--Size 颗粒纹理粒径（1-10）
--LuminanceContribution  描述场景中噪点颗粒对亮度的灵敏度，较低的值意味着暗区域的噪音较少
--Intensity 颗粒纹理强度系数，0表示无颗粒纹理效果，1表示颗粒纹理很强
function CameraManager:Grain(p1,size,L,Tintensity)
	local CameraEffect = world:CreateObject('Grain','Grain',self.CurrentCamera)
	self.CurrentCameraEffect = CameraEffect
	CameraEffect.Size = size
	CameraEffect.LuminanceContribution = L
	CameraEffect.Intensity = Tintensity

end

--光溢出
--XX:Bloom(world.CurrentCamera,1,10,10)
--[[
Intensity 光溢出程度系数，0表示无光溢出效果，1表示光溢出很强
Threshold 阀值，筛选掉小于该值的像素，对剩下的像素集合进行衍射处理
Size 光溢出面积的尺寸
]]
function CameraManager:Bloom(p1,Tintensity,threshold,size)
	local CameraEffect = world:CreateObject('Bloom','Bloom',self.CurrentCamera)
	self.CurrentCameraEffect = CameraEffect
	CameraEffect.Size = size
	CameraEffect.Intensity = Tintensity
	CameraEffect.Threshold = threshold
end

--[[
冰特效
DistortDensity 扭曲密度 取值范围为0-5
DistortIntensity 扭曲强度 取值范围为0-5
IceTexture 引用图片
XX:Ice(world.CurrentCamera,2,2)
]]
function CameraManager:Ice(p1,DistortDensity,DistortIntensity,IceTexture)
	local CameraEffect = world:CreateObject('Ice','Ice',self.CurrentCamera)
	self.CurrentCameraEffect = CameraEffect
	CameraEffect.DistortDensity = DistortDensity
	CameraEffect.DistortIntensity = DistortIntensity
	if IceTexture ~= nil then 
		CameraEffect.IceTexture = IceTexture
	end
end

--[[
水特效
DistortDensity 扭曲密度 取值范围0-5
DistortIntensity 扭曲强度 取值范围0-5
WaterSpeed 水流速度 取值范围0-5
WaterColorIntensity 水体颜色的强度 取值范围0-5
WaterColor 水体颜色
WaterColorRadius 水体特效半径 取值范围0-1
XX:Water(world.CurrentCamera,0.5,2,0.3,6,Color(255,100,110,255),0.8)
]]
function CameraManager:Water(p1,DistortDensity,DistortIntensity,WaterSpeed,WaterColorIntensity,WaterColor,WaterColorRadius,img)
	local CameraEffect = world:CreateObject('Water','Water',self.CurrentCamera)
	self.CurrentCameraEffect = CameraEffect
	CameraEffect.DistortDensity = DistortDensity
	CameraEffect.DistortIntensity = DistortIntensity
	CameraEffect.WaterSpeed = WaterSpeed
	CameraEffect.WaterColorIntensity = WaterColorIntensity
	CameraEffect.WaterColor = WaterColor
	CameraEffect.WaterColorRadius = WaterColorRadius
	if img ~= nil then
		CameraEffect.WaterTexture = img
	end
end
--[[
电磁特效
Speed 电磁特效产生速度 取值范围：0-10
Offset 相对偏移位置 取值范围：0-10
ColorOverlay 颜色图层 取值范围：0-3
BlockSize1、BlockSize2 电测小图块的长宽 取值范围：0.01-1（随机取值）
Block1Intensity，Block2Intensity 图块的显示强度 取值范围0-20
RGBSplit_Intensity 人物左右偏移量 取值范围0-5
XX:Glitch(world.CurrentCamera,7,6,2,Vector2(0.2,0.2),Vector2(0.2,0.2),15,9,0.5)
]]
function CameraManager:Glitch(p1,Speed,Offset,ColorOverlay,BlockSize1,BlockSize2,Block1Intensity,Block2Intensity,RGBSplit_Intensity)
	local CameraEffect = world:CreateObject('Glitch','Glitch',self.CurrentCamera)
	self.CurrentCameraEffect = CameraEffect
	CameraEffect.Speed = Speed
	CameraEffect.Offset = Offset
	CameraEffect.ColorOverlay = ColorOverlay
	CameraEffect.BlockSize1 = BlockSize1
	CameraEffect.BlockSize2 = BlockSize2
	CameraEffect.Block1Intensity = Block1Intensity
	CameraEffect.Block2Intensity = Block2Intensity
	CameraEffect.RGBSplit_Intensity = RGBSplit_Intensity
end

--[[
视野拉伸特效 
ScaleFactor 视野拉伸的重影间隔 取值范围0-5
Sample 重影个数 取值0-20（下图为取2和5的区别
Center 重影二维偏移量 取值0-1

]]
function CameraManager:RadialBlur(p1,ScaleFactor,Sample,Center)
	local CameraEffect = world:CreateObject('RadialBlur','RadialBlur',self.CurrentCamera)
	self.CurrentCameraEffect = CameraEffect
	CameraEffect.ScaleFactor = ScaleFactor
	CameraEffect.Sample = Sample
	CameraEffect.Center = Center
end

--摧毁当前特效
function CameraManager:DestroyCameraEffect(DesTime)
	if self.CurrentCameraEffect == nil then 
		print("该相机没有挂载特效")
		return 
	end
	wait(DesTime)
	self.CurrentCameraEffect:Destroy()
end

return CameraManager



























