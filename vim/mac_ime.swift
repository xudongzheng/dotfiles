import Carbon

// This script is largely based on https://bit.ly/3RYSGWZ.

func getInputSource() -> String {
	let inputSource = TISCopyCurrentKeyboardInputSource().takeUnretainedValue()
	return unsafeBitCast(
		TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID),
		to: NSString.self
	) as String
}

func setInputSource(to id: String) -> Bool {
	if getInputSource() == id {
		return true
	}
	let filter = [kTISPropertyInputSourceID!: id] as NSDictionary
	let inputSources = TISCreateInputSourceList(filter, false).takeUnretainedValue() as NSArray as! [TISInputSource]
	guard !inputSources.isEmpty else {
		return false
	}
	let inputSource = inputSources[0]
	TISSelectInputSource(inputSource)
	return true
}

// If no argument given, print current layout. Otherwise set argument as layout.
if CommandLine.arguments.count == 1 {
	let inputSource = getInputSource()
	print(inputSource)
} else {
	let success = setInputSource(to: CommandLine.arguments[1])
	if !success {
		print("failed to set input source")
	}
}
