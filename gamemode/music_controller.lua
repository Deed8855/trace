include("shared.lua")

local sounds = {
    "ambient/atmosphere/city_skypass1.wav",
    "ambient/atmosphere/city_skypass2.wav",
    "ambient/atmosphere/combine_city.wav",
    "ambient/atmosphere/city_beacon_loop1.wav",
    "ambient/atmosphere/indoor_rain1.wav",
    "ambient/atmosphere/indoor_rain2.wav",
    "ambient/atmosphere/rainroofa.wav",
    "ambient/atmosphere/rainroofb.wav",
    "ambient/atmosphere/cave_hit1.wav",
    "ambient/atmosphere/cave_hit2.wav",
    "ambient/atmosphere/cave_hit3.wav",
    "ambient/atmosphere/cave_hit4.wav",
    "ambient/atmosphere/cave_hit5.wav"
}

local function playRandomSound()
    local soundPath = table.Random(sounds)
    BroadcastLua("surface.PlaySound('" .. soundPath .. "')")
end

local function playNextSound()
    playRandomSound()
    timer.Simple(10, playNextSound)
end

playNextSound()

-- Randomize the table
local function shuffleTable(t)
  for i = #t, 2, -1 do
      local j = math.random(i)
      t[i], t[j] = t[j], t[i]
  end
end

shuffleTable(sounds)

-- Prevent overlapping sounds
local isPlaying = false

local function playRandomSound()
  if not isPlaying then
      isPlaying = true
      local soundPath = table.Random(sounds)
      BroadcastLua("surface.PlaySound('" .. soundPath .. "')")
      timer.Simple(SoundDuration(soundPath), function() isPlaying = false end)
  end
end

local function playNextSound()
  playRandomSound()
  timer.Simple(10, playNextSound)
end

playNextSound()
