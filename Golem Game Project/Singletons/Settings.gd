#extends Control

# Settings panel to send signals to whatever scene it's in to control the audio in the scene


var soundPlaying = false;
var musicPlaying = false;
var soundVolume = 1;
var musicVolume = 1;

var mutedSoundVolume = null
var mutedMusicVolume = null
#mute = 0(false) // not muted = 1(true)


func update_audio_bus_configurations():
	if soundVolume == 0:
		soundPlaying = true
		mutedSoundVolume = 0
	if musicVolume == 0:
		musicPlaying = true
		mutedMusicVolume = 0
	AudioServer.set_bus_mute(AudioServer.get_bus_index("SoundEffects"),soundPlaying);
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"),linear2db(soundVolume));
	AudioServer.set_bus_mute(AudioServer.get_bus_index("BackgroundMusic"),musicPlaying);
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("BackgroundMusic"),linear2db(musicVolume));
	print("Sound: ", soundPlaying, "/", soundVolume, " || Music: ",musicPlaying, "/", musicVolume)



