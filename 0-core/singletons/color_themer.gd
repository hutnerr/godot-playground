extends Node

class_name ColorThemer

# this is also a Singleton in Autoload known as ColorManager

enum colors { PRIMARY, SECONDARY, TERTIARY }

const COLOR_VALUES = {
	ColorThemer.colors.PRIMARY: Color("#282828"),
	ColorThemer.colors.SECONDARY: Color("#ebdbb2"),
	ColorThemer.colors.TERTIARY: Color("#ffbf00")
}

func get_color(color: ColorThemer.colors) -> Color:
	# FIXME
	if color in colors:
		return COLOR_VALUES[color]
	return Color()

func get_primary() -> Color:
	return COLOR_VALUES[ColorThemer.colors.PRIMARY]
	
func get_secondary() -> Color:
	return COLOR_VALUES[ColorThemer.colors.SECONDARY]
	
func get_tertiary() -> Color:
	return COLOR_VALUES[ColorThemer.colors.TERTIARY]
