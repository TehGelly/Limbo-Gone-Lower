
# RANDOMNESS

## libc rand

- rand() is a library function that returns a random 32 bit integer. It it utilized by three functions:

### frand

- Three overloaded versions of frand exist:

#### frand(void)

- Acquires a random floating point number from 0.0 to 1.0.
- Usages:
	- *Gfx_Base::DrawTexturedQuad2DBloomExpandRedContrast*
	- *DisconnectBoneRefreshSprites*
	- *RandomChildState::SelectRandomChild*
	- *Water::AddWave* (ten-ish times)
	- *Water::Integrate* (five-ish times)
	- *MenuController::ViewUpdate* (random brightness fluctuations)
	- *MenuController::Update* (unknown modifier to MenuController (probably also brightness lmao))
	- *RenderTarget::BlitExpandRed*
	- *NDistRandomProxy* (based on proxy naming convention, is a script function)

#### frand(float arg0)

- Equivalent to float_rand(float max).
- Used in *Water::Integrate* (callsites are both frand(0.13)) [me me too stupid to understand or want to understand water engine, but.... possible floating point error crash ahoy?]

#### frand(float arg0, float arg1)

- Equivalent to your favorite *float_rand_range(float min, float max)* implementation.
- Used multiple times in *ParticleSimpleStateStruct::Reset*, *GetRandomVector3f* (script engine function)

### ParticleEmitter2::Spawn

- Used as an argument to *ParticleSimpleStateStruct::Reset*. Likely used for particles emitted by saws (rand seed might technically be retrievable based on footage of a saw?)

### RandFunction/FrandFunction

- Wrappers used for the above functionalities for the script engine. It is currently unclear how rand/frand are used in scripts.

## AKRANDOM

- The AK sound engine has its own implementation of randomness - however, it's not a focus of the current effort to attempt to discern anything pertaining to the sound engine functionality.