handleJson = (err,data) ->
	if (err)
		return console.log(err)
	trelloData = JSON.parse(data)
	output = ""
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
		if x.name.toLowerCase() == 'bugs'
			for i in x.checkItems
				if i.id == id
					return i

findCheckListItems = (trelloData, id) ->
	for x in trelloData.checklists
		if x.name.toLowerCase() == 'bugs' and x.id == id
			return x


fs = require('fs');
fs.readFile('/Users/adamengland/Downloads/development-board.json', "UTF-8", handleJson)
