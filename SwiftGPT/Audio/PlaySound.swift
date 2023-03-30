import AVFoundation

class AudioClass {
	var repsSoundEffect: AVAudioPlayer?
	
	func play() {
		
		if let url = Bundle.main.url(forResource: "success", withExtension: "mp3", subdirectory: "Audio") {
			print(url)
			do {
				repsSoundEffect = try AVAudioPlayer(contentsOf: url)
				repsSoundEffect?.play()
			} catch {
				print("Error!")
			}
		} else {
			print("Error: file not found")
		}
	}
}

func playSound () {
	let sound = AudioClass()
	sound.play()
}
