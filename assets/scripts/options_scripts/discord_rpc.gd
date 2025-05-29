extends Control

func _ready():
	DiscordRPC.app_id = 1377659302126424166  #Application ID из discord.com/developers/applications
	DiscordRPC.details = "тестирую дс рпс"
	DiscordRPC.large_image = "fm"  #название(ключ) изображения из Art Assets
	DiscordRPC.large_image_text = "тестирую"
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	DiscordRPC.refresh() #обновлять после изменения значений
