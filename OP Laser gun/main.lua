--Laser Gun 

body = nil
t0 = nil
t1 = nil

function init()
	--Register tool and enable it
	RegisterTool("lasergun", "loc@LASER_GUN", "MOD/vox/lasergun.vox")
	SetBool("game.tool.lasergun.enabled", true)

	--Laser gun has 60 seconds of ammo. 
	--If played in sandbox mode, the sandbox script will make it infinite automatically
	SetFloat("game.tool.lasergun.ammo", 60)
	
	ready = 0
	fireTime = 0
	
	openSnd = LoadSound("MOD/snd/open.ogg")
	closeSnd = LoadSound("MOD/snd/close.ogg")
	laserSnd = LoadLoop("MOD/snd/laser.ogg")
	hitSnd = LoadLoop("MOD/snd/hit.ogg")
end

--Return a random vector of desired length
function rndVec(length)
	local v = VecNormalize(Vec(math.random(-100,100), math.random(-100,100), math.random(-100,100)))
	return VecScale(v, length)	
end

function tick(dt)
	--Check if laser gun is selected
	if GetString("game.player.tool") == "lasergun" then
	
		--Check if tool is firing
		if GetBool("game.player.canusetool") and InputDown("usetool") and GetFloat("game.tool.lasergun.ammo") > 0 then
			if ready == 0 then 
				PlaySound(openSnd) 
			end
			ready = math.min(1.0, ready + dt*4)
			if ready == 1.0 then
				PlayLoop(laserSnd)
				local t = GetCameraTransform()
				local fwd = TransformToParentVec(t, Vec(0, 0, -1))
				local maxDist = 20
				local hit, dist, _, _ = QueryRaycast(t.pos, fwd, maxDist)
				if not hit then
					dist = maxDist
				end
				
				--Laser line start and end points
				local s = VecAdd(VecAdd(t.pos, Vec(0, -0.5, 0)),VecScale(fwd, 1.5))
				local e = VecAdd(t.pos, VecScale(fwd, dist))

				--Draw laser line in ten segments with random offset
				local last = s
				for i=1, 10 do
					local tt = i/10
					local p = VecLerp(s, e, tt)
					p = VecAdd(p, rndVec(0.2*tt))
					DrawLine(last, p, 1, 0.5, 0.7)
					last = p
				end

				--Make damage and spawn particles
				if hit then
					PlayLoop(hitSnd, e)
					--SpawnFire(e)
					MakeHole(e, 1.0, 1.0, 1.0, true)
					--SpawnParticle("fire", e, rndVec(0.5), 0.5, 0.5)
					local size = 0.5
					ParticleReset()
					ParticleType("fire")
					ParticleDrag(0.001)
					ParticleGravity(0, 1)
					ParticleColor(1, 0.9, 0.8, 1, 0.5, 0.4)
					ParticleAlpha(0.5, 0.0)
					ParticleRadius(size * 0.1, size)
					ParticleEmissive(10, 0)
					SpawnParticle(e, rndVec(0.5), 0.5)

					--SpawnParticle("smoke", e, rndVec(0.5), 1.0, 1.0)
					size = 1.0
					ParticleReset()
					ParticleType("smoke")
					ParticleDrag(0)
					ParticleGravity(-2, -4)
					ParticleColor(1, 1, 1)
					ParticleAlpha(0.5, 0.0, "linear", 0.05)
					ParticleRadius(0.5 * size, size)
					ParticleCollide(0, 1)
					SpawnParticle(e, rndVec(0.5), 1.0)
				end
				
				fireTime = fireTime + dt
				SetFloat("game.tool.lasergun.ammo", math.max(0, GetFloat("game.tool.lasergun.ammo")-dt))
				
				--Provide ammo display with one decimal
				SetString("game.tool.lasergun.ammo.display", tostring(math.floor(GetFloat("game.tool.lasergun.ammo")*10)/10))
			end
		else
			fireTime = 0
			if ready == 1 then
				PlaySound(closeSnd)
			end
			ready = math.max(0.0, ready - dt*4)
		end
	
		local b = GetToolBody()
		if b ~= 0 then
			local shapes = GetBodyShapes(b)

			--Control emissiveness
			for i=1, #shapes do
				SetShapeEmissiveScale(shapes[i], ready)
			end
	
			--Add some light
			if ready > 0 then
				local p = TransformToParentPoint(GetBodyTransform(body), Vec(0, 0, -2))
				PointLight(p, 1, 0.5, 0.7, ready * math.random(10, 15) / 10)
			end
			
			--Move tool
			local offset = VecScale(rndVec(0.01), ready*math.min(fireTime/5, 1.0))
			SetToolTransform(Transform(offset))
			
			--Animate 
			local t	= 1-ready
			t = t*t
			offset = t*0.15
			
			if b ~= body then
				body = b
				--Get default transforms
				t0 = GetShapeLocalTransform(shapes[2])
				t1 = GetShapeLocalTransform(shapes[3])
			end

			t = TransformCopy(t0)
			t.pos = VecAdd(t.pos, Vec(offset))
			SetShapeLocalTransform(shapes[2], t)

			t = TransformCopy(t1)
			t.pos = VecAdd(t.pos, Vec(-offset))
			SetShapeLocalTransform(shapes[3], t)
		end
	end
end

