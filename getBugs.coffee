handleJson = (err,data) ->
	if (err)
		return console.log(err)
	trelloData = JSON.parse(data)
	#trelloData = data
	output = "cardName;state;bugName;severe\n"
	completedBugs = []
	for card in trelloData.cards
		severe = false
		for label in card.labels
			if label.color == 'red'
				severe = true
		if card.checkItemStates.length > 0
			for checkItem in card.checkItemStates
				checkListItem = findCheckListItem(trelloData, checkItem.idCheckItem)
				if checkListItem
					completedBugs.push checkItem.idCheckItem
					output = output + "#{card.name};#{checkItem.state};#{checkListItem.name};#{severe}\n"
		for idChecklists in card.idChecklists
			cl = findCheckListItems(trelloData, idChecklists)
			if cl
				for i in cl.checkItems
					if completedBugs.indexOf(i.id) == -1
						output = output + "#{card.name};incomplete;#{i.name};#{severe}\n"
	fs.writeFile("bugs.csv", output)

findCheckListItem = (trelloData, id) ->
	for x in trelloData.checklists
		if x.name.toLowerCase() == 'bugs' or x.name.toLowerCase() == 'bug'
			for i in x.checkItems
				if i.id == id
					return i

findCheckListItems = (trelloData, id) ->
	for x in trelloData.checklists
		if (x.name.toLowerCase() == 'bugs' or x.name.toLowerCase() == 'bugs') and x.id == id
			return x


fs = require('fs');
fs.readFile('/Users/adamengland/Downloads/development-board.json', "UTF-8", handleJson)

###
Trello = require("node-trello")
t = new Trello("81fd0bf0fb6e8d3768e0635d89b2d463", "adea148c554729d229eec3d404491325760ae8e4f15c998dc13ef97369f477e9")
t.get "1/boards/501aae06c69a7d65341c8ba3/checklists", (err, data) ->
	checklists = data
	t.get "1/boards/501aae06c69a7d65341c8ba3/cards", (err, data) ->
		trelloData = {cards : data, checkLists : checklists}
		if trelloData
			handleJson err, trelloData
###