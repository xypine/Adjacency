extends Node


const all = [-1, 0, 1, 2, 3, 4]
const any = -100
const x = any


#t, d, l, r : <list of possible tiles>
#var possible = {
#	-1: [[0, 0, 0, 0]],
#	1: [[1, 1, 1, 1], [1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 0]],
#	0: [[0, 0, 0, 0], [0, x, x, x], [x, 0, x, x], [x, x, 0, x], [x, x, x, 0]],
#	3: [[x, x, 3, 3], [-1, -1, -1, -1], [4, x, 3, x]], # [1, 1, 1, 1]
#	4: [[4, 4, x, x], [4, -1, x, x], [-1, 4, x, x], [-1, -1, -1, -1]], # [1, 1, 1, 1]
#}

var possible = {
	-1: [[x, x, x, x]],
	0: [[-1, x, -1, x]],
	1: [[-1, -1, x, x]],
	2: [[-1, x, x, -1]],
	3: [[x, -1, x, -1]], #[[x, -1, x, -1]],
	4: [[x, -1, -1, x]]
}

var forbidden = {
#	[0, possible[0][0]]: [x, -1, -1, -1],
#	[0, possible[0][1]]: [-1, -1, x, -1],
	[0, possible[0][0]]: [[0, 0, 0, 0], [x, 2, 4, x], [x, -1, x, -1]],
	[2, possible[2][0]]: [[2, 2, 2, 2], [x, 0, 3, x], [x, -1, -1, x]],

	[3, possible[3][0]]: [[3, 3, 3, 3], [4, 4, x, x]],
	[4, possible[4][0]]: [[4, 4, 4, 4], [3, 3, x, x]],
}


func getAvailable(neighbours = [], available = []):
	var out = []
	var logz = ""
	for i in available:
		var ruleset = possible[i]
		
		var possible = false
		var possible_overide = false
		for ni in range(neighbours.size()):
			var n = neighbours[ni]
			if str(n) != "":
				for r in ruleset:
					var s = r[ni]
					var anti = []
					var fullanti = []
					if forbidden.has([i, r]):
						fullanti = forbidden[[i, r]]
						for a in fullanti:
							anti.append(a[ni])
					logz += "using anti" + str(anti) + "\n"
					if n.state in anti: # and anti != any
						possible = false
						possible_overide = false
						logz += "antipattern" + str(fullanti) + " matched neighbor" + str(n) + " at index" + str(ni) + "(" + str(anti) + "==" + str(n.state) + ")\n"
					elif s == n.state or s == any:
						possible = true
						logz += "pattern" + str(r) + " matched neighbor" + str(n) + " at index" + str(ni) + "(" + str(s) + "==" + str(n.state) + ")\n"
					else:
						logz += "pattern" + str(r) + " mismatched neighbor" + str(n) + " at index" + str(ni) + "(" + str(s) + "!=" + str(n.state) + ")\n"
						possible = false
						possible_overide = true
			if possible and not possible_overide:
				if not i in out:
					logz += "Marking " + str(i) + " as possible. (p:" + str(possible) + ", p_o:" + str(possible_overide) + ")\n"
					out.append(i)
				else:
					logz += "Not Marking " + str(i) + " as possible. (Marked already) (p:" + str(possible) + ", p_o:" + str(possible_overide) + ")\n"
			else:
				logz += "Not Marking " + str(i) + " as possible. (p:" + str(possible) + ", p_o:" + str(possible_overide) + ")\n"
	return [out, logz]
func _ready():
	print("Ruleset registered.")
#	var neigh = [tileBasic]
#	print("Ruletest ()")
