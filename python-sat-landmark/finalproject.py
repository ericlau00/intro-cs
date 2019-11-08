#!/usr/bin/python
print "Content-type: text/html\n"
import random 
import cgitb
cgitb.enable()
import cgi
import matplotlib
matplotlib.use("Agg")
import matplotlib.patches as mpatches
import matplotlib.pyplot as plt

plt.clf()

def getDict(F):
    a = {}
    for keys in F.keys():
        a[keys] = F[keys].value
    return a

form = getDict(cgi.FieldStorage())
graph = -1
if "graph" in form:
    graph = form["graph"]
maps = -1
if "map" in form:
    maps = form["map"]

data = open("csv/LPC_LL_OpenData_2015Nov.csv").read().rstrip("\n").split("\n")
if maps == "School District Boundaries":
    data2 = open("csv/nysd.csv").read().rstrip('\n').split('\n')
else:
    data2 = open("csv/nybb.csv").read().rstrip('\n').split('\n')
data2 = data2[1:]
data3 = open("csv/LPC_HD_OpenData_2015Nov.csv").read().rstrip("\n").split("\n")
data3 = data3[1:]

boroughs = {"Brooklyn": "BK", "Manhattan": "MN", "Staten Island": "SI", "The Bronx": "BX", "Queens" :"QN"}
landmarks = ["Historic District", "Individual Landmark", "Interior Landmark", "Scenic Landmark"]
if "userinput" in form and form["userinput"] == "True":
    if "street" in form and form["street"] != "Type street name or address":
        landmarks.append(form["street"])
if "userinput2" in form and form["userinput2"] == "True":
    if "landmark" in form and form["landmark"] != "Type landmark name":
        landmarks.append(form["landmark"])
HD = {"Brooklyn": {}, "Manhattan": {}, "Queens": {}, "Staten Island": {}, "The Bronx": {}}
d = {}
coordx = {}
coordy = {}
for i in boroughs:
    boroughs[i] 
    d[boroughs[i]] = 0
    for x in landmarks:
        key = boroughs[i] + " and " + x
        d[key] = 0
        d[x] = 0
        coordx[key] = []
        coordy[key] = []

for i in range(len(data)):
    data[i] = data[i].split(",")

bColors = {"BK": "b", "MN": "g", "SI": "r", "BX": "#FFA500", "QN": "m"}
colors = {"b": "blue", "g": "green", "r": "red", "#FFA500": "#FFA500", "m": "magenta"}
landmarkColors = {"Individual Landmark": "#0000FF", "Interior Landmark": "red", "Scenic Landmark": "green", "Historic District": "#808080"}
if "userinput" in form and form["userinput"] == "True":
    if "street" in form and form["street"] != "Type street name or address":
        landmarkColors[form["street"]] = "black"
if "userinput2" in form and form["userinput2"] == "True":
    if "landmark" in form and form["landmark"] != "Type landmark name":
        landmarkColors[form["landmark"]] = "#964B00"
legend = []

for b in boroughs:
    boroughYears = {}
    boroughX = []
    boroughY = []
    for i in data:
        if i[4] == boroughs[b]:
            d[boroughs[b]] += 1
            for L in landmarks:
                if "street" in form and L == form["street"]:
                    if len(i) >= 11 and "POINT" in i[3] and (form["street"].upper() in i[9] or form["street"].upper() in i[10]):
                        coordx[boroughs[b] + " and " + form["street"]].append(i[3].strip("POINT ()").split()[0])
                        coordy[boroughs[b] + " and " + form["street"]].append(i[3].strip("POINT ()").split()[1])
                if "landmark" in form and L == form["landmark"]:
                    if len(i) >= 9 and "POINT" in i[3] and (form["landmark"].upper() in i[8].upper()):
                        coordx[boroughs[b] + " and " + form["landmark"]].append(i[3].strip("POINT ()").split()[0])
                        coordy[boroughs[b] + " and " + form["landmark"]].append(i[3].strip("POINT ()").split()[1])
                if len(i) >= 12 and i[12] == L:
                    if "POINT" in i[3] and i[12] != "Historic District":
                        coordx[boroughs[b] + " and " + L].append(i[3].strip("POINT ()").split()[0])
                        coordy[boroughs[b] + " and " + L].append(i[3].strip("POINT ()").split()[1])
                    d[boroughs[b] + " and " + L] += 1
                    d[L] += 1
            if len(i) >= 14 and ("Yes" in i[13]) and len(i[14]) > 1 and i[14][1].isalpha():
                if i[14][1:] in HD[b].keys():
                    HD[b][i[14][1:]] += 1
                else:
                    HD[b][i[14][1:]] = 1
            if len(i) >= 24 and i[24].count("/") == 2:
                i[24] = i[24].split("/")
                if i[24][2] in boroughYears:
                    boroughYears[i[24][2]] += 1
                else:
                    boroughYears[i[24][2]] = 1
                        
    if b in form and form[b] == "True":
        sort = sorted(boroughYears.keys())
        if graph == "Landmark total per year":
            for x in range(len(sort)):
                boroughX.append(sort[x])
                if x == 0:
                    boroughY.append(boroughYears[sort[x]])
                if x > 0:
                    subtotal = 0 
                    for sub in sort[:x + 1]:
                        subtotal += boroughYears[sub]
                    boroughY.append(subtotal)
            plt.ylabel("Total Landmarks")
            plt.title("Total Landmarks per year in New York City from 1965-2017*")
        if graph == "Landmarks added per year":
            for x in sort:
                boroughX.append(x)
                boroughY.append(boroughYears[x])
            plt.ylabel("Landmarks Added")
            plt.title("Landmarks added per year in New York City from 1965-2017*")
        plt.plot(boroughX, boroughY, bColors[boroughs[b]])
        boroughLegend = mpatches.Patch(color = colors[bColors[boroughs[b]]], label= b)
        legend.append(boroughLegend)
        plt.legend(handles=legend, loc = 2)

plt.xlabel("Years")
plt.savefig("img/graph.png")

def getCoords(dataset):
    xcor = []
    ycor = []
    for i in range(len(dataset)):
        dataset[i] = dataset[i].split("\"")
        dataset[i][1] = dataset[i][1].strip("MULTIPOLYGON")
        dataset[i] = dataset[i][1].split(" (")
        dataset[i] = dataset[i][1:]
        for y in range(len(dataset[i])):
            dataset[i][y] = dataset[i][y].strip("(),")
        for x in range(len(dataset[i])):
            dataset[i][x] = dataset[i][x].split(',')
            sublistx=[]
            sublisty=[]
            for y in range(len(dataset[i][x])):
                dataset[i][x][y] = dataset[i][x][y].split()
                sublistx.append(dataset[i][x][y][0])
                sublisty.append(dataset[i][x][y][1])
            xcor.append(sublistx)
            ycor.append(sublisty)
    return xcor, ycor
boroughOrSchoolX, boroughOrSchoolY = getCoords(data2)

for i in range(len(data3)):
    for b in boroughs:
        if "," + boroughs[b] + ",Yes" in data3[i]:
            lat, lon = getCoords([data3[i]])
            coordx[boroughs[b] + " and Historic District"].append(lat)
            coordy[boroughs[b] + " and Historic District"].append(lon)
            
header = """<!DOCTYPE html>
<html>
<head>
    <link rel=\"stylesheet\" href=\"style.css\">
    <title> NYC Landmarks </title>
</head>
<body>
    <h1 id="1"> NYC Landmarks </h1>
    <h3> Lau, Eric and Sultan, Ahmed / Konstantinovich pd 4 intro Comp Sci 2 </h3>
    <br>
"""
print header

table = "<center><table class=\"main\">\n"
table += "<tr>\n"
table += "<th class=\"main\"> Boroughs </th>\n"
table += "<th class=\"main\"> Total Landmarks </th>\n"
table += "<th class=\"main\"> Landmarks in Historic Districts </th>\n"
table += "<th class=\"main\"> Individual Landmarks </th>\n"
table += "<th class=\"main\"> Interior Landmarks </th>\n"
table += "<th class=\"main\"> Scenic Landmarks </th>\n"
table += "</tr>\n"
totalDistricts = 0
for b in boroughs:
    table += "<tr>\n"
    table += "<td class=\"main\">" + b + "</td>\n"
    table += "<td class=\"main\">" + str(d[boroughs[b]]) + "</td>\n"
    if ("street" in form and form["street"] != "Type street name or address") or "landmark" in form and form["landmark"] != "Type landmark name":
        if "street" in form and "landmark" in form:
            for L in landmarks:
                if L != form["street"] and L != form["landmark"]:
                    if L == "Historic District":
                        table += "<td class=\"main\">" + str(d[boroughs[b] + " and " + L]) + " (" + str(len(HD[b].keys())) + " districts)" + "</td>\n"
                        totalDistricts += len(HD[b].keys())
                    else:
                        table += "<td class=\"main\">" + str(d[boroughs[b] + " and " + L]) + "</td>\n"
        elif "street" in form:
            for L in landmarks:
                if L != form["street"]:
                    if L == "Historic District":
                        table += "<td class=\"main\">" + str(d[boroughs[b] + " and " + L]) + " (" + str(len(HD[b].keys())) + " districts)" + "</td>\n"
                        totalDistricts += len(HD[b].keys())
                    else:
                        table += "<td class=\"main\">" + str(d[boroughs[b] + " and " + L]) + "</td>\n"
        elif "landmark" in form:
            for L in landmarks:
                if L != form["landmark"]:
                    if L == "Historic District":
                        table += "<td class=\"main\">" + str(d[boroughs[b] + " and " + L]) + " (" + str(len(HD[b].keys())) + " districts)" + "</td>\n"
                        totalDistricts += len(HD[b].keys())
                    else:
                        table += "<td class=\"main\">" + str(d[boroughs[b] + " and " + L]) + "</td>\n"
    else:
        for L in landmarks:
            if L == "Historic District":
                table += "<td class=\"main\">" + str(d[boroughs[b] + " and " + L]) + " (" + str(len(HD[b].keys())) + " districts)" + "</td>\n"
                totalDistricts += len(HD[b].keys())
            else:
                table += "<td class=\"main\">" + str(d[boroughs[b] + " and " + L]) + "</td>\n"
    table += "</tr>\n"
table += "<tr>\n"
table += "<td class=\"main\"> Total </td>\n"
table += "<td class=\"main\">" + str(d["BK"] + d["MN"] + d["SI"] + d["BX"] + d["QN"]) + "</td>\n"
if ("street" in form and form["street"] != "Type street name or address") or ("landmark" in form and form["landmark"] != "Type landmark name"):
    if "street" in form and "landmark" in form:
        for L in landmarks:
            if L != form["street"] and L != form["landmark"]:
                if L == "Historic District":
                    table += "<td class=\"main\">" + str(d["BK and " + L] + d["MN and " + L] + d["SI and " + L] + d["BX and " + L] + d["QN and " + L]) + " (" + str(totalDistricts) + " districts)" + "</td>\n"
                else:
                    table += "<td class=\"main\">" + str(d["BK and " + L] + d["MN and " + L] + d["SI and " + L] + d["BX and " + L] + d["QN and " + L]) + "</td>\n"
    elif "street" in form:
        for L in landmarks:
            if L != form["street"]:
                if L == "Historic District":
                    table += "<td class=\"main\">" + str(d["BK and " + L] + d["MN and " + L] + d["SI and " + L] + d["BX and " + L] + d["QN and " + L]) + " (" + str(totalDistricts) + " districts)" + "</td>\n"
                else:
                    table += "<td class=\"main\">" + str(d["BK and " + L] + d["MN and " + L] + d["SI and " + L] + d["BX and " + L] + d["QN and " + L]) + "</td>\n"
    elif "landmark" in form:
        for L in landmarks:
            if L != form["landmark"]:
                if L == "Historic District":
                    table += "<td class=\"main\">" + str(d["BK and " + L] + d["MN and " + L] + d["SI and " + L] + d["BX and " + L] + d["QN and " + L]) + " (" + str(totalDistricts) + " districts)" + "</td>\n"
                else:
                    table += "<td class=\"main\">" + str(d["BK and " + L] + d["MN and " + L] + d["SI and " + L] + d["BX and " + L] + d["QN and " + L]) + "</td>\n"
else:
    for L in landmarks:
        if L == "Historic District":
            table += "<td class=\"main\">" + str(d["BK and " + L] + d["MN and " + L] + d["SI and " + L] + d["BX and " + L] + d["QN and " + L]) + " (" + str(totalDistricts) + " districts)" + "</td>\n"
        else:
            table += "<td class=\"main\">" + str(d["BK and " + L] + d["MN and " + L] + d["SI and " + L] + d["BX and " + L] + d["QN and " + L]) + "</td>\n"
table += "</tr>\n"
table += "</table></center>\n"
print table

print "<br>"

fileyes = open("csv/landmarksShort1.csv", "r")
LDATAs = fileyes.read().rstrip('\n')
LDATAs = LDATAs.split('\n')

def randomizer(dat):
    a = random.randint(1, len(dat) - 1)
    q = dat[a]
    b = q.split(',')
    print "<center>"
    print '<table> \n<tr> <th> Landmark </th> <th> Image </th> <th> District of Landmark </th> </tr>'
    if b[1] == 'TRUE':
        r = '<b>' + b[0] + '</b> - <i>' + b[2] + '</i>'
    else:
        r = '<b>' + b[0] + '</b>'
    print  '<tr> <td class=\"more\">' + r + '</td> <td class=\"more\">' + '<img style=\"width:50%;height:auto\" src = \"moreimages/' + b[3] + '\"></td> <td class=\"more\"> <b>' + b[4] + '</b></td> </tr>'
    print '</table>'
    print "</center>"

randomizer(LDATAs)

print "<table>"
print "<tr>"
print "<td>"

image = "<img src=\"img/graph.png\">"
print image
        
plt.clf()

dC = {}
if maps == "School District Boundaries":
    for i in range(121):
        if (i >= 57 and i <= 70) or i == 0 or i == 1 or (i >= 16 and i <= 17) or (i >= 10 and i <=  12) or i == 106 or (i >= 72 and i <= 74) or (i >= 20 and i <=38):
            dC[i] = "b"
        if (i >= 99 and i <= 105) or i == 75 or (i >= 109 and i <= 111) or i == 118 or i == 7:
            dC[i] = "g"
        if (i >= 3 and i <= 6) or (i >= 76 and i <= 98) or i == 18 or i == 19 or i == 2 or i == 119 or i == 120:
            dC[i] = "#FFA500"
        if (i >= 39 and i <= 56) or (i >= 13 and i <= 15) or i == 107 or i == 108 or i == 71 or i == 9 or i == 8:
            dC[i] ="m"
        if i >= 112 and i <=117:
            dC[i] = "r"
else:
    for i in range(107):
        if (i >= 0 and i <= 3):
            dC[i] = "r"
        if (i >= 4 and i <= 36):
            dC[i] = "g"
        if (i >= 37 and i <= 60):
            dC[i] = "#FFA500"
        if (i >= 61 and i <= 87):
            dC[i] = "b"
        if (i >= 88 and i <= 106):
            dC[i] = "m"

for i in range(len(boroughOrSchoolX)):
    if "Brooklyn2" in form:
        if dC[i] == "b":
            plt.plot(boroughOrSchoolX[i],boroughOrSchoolY[i], dC[i])
    if "Manhattan2" in form:
        if dC[i] == "g":
            plt.plot(boroughOrSchoolX[i],boroughOrSchoolY[i], dC[i])
    if "The Bronx2" in form:
        if dC[i] == "#FFA500":
            plt.plot(boroughOrSchoolX[i],boroughOrSchoolY[i], dC[i])
    if "Queens2" in form:
        if dC[i] == "m":
            plt.plot(boroughOrSchoolX[i],boroughOrSchoolY[i], dC[i])
    if "Staten Island2" in form:
        if dC[i] == "r":
            plt.plot(boroughOrSchoolX[i],boroughOrSchoolY[i], dC[i])

plt.ylabel("Longitude")
plt.xlabel("Latitude")
plt.savefig("img/image.png")

for b in boroughs:
    search = b + "2"
    if search in form:
        for L in landmarks:
            if "street" in form and L == form["street"]:
                search2 = "street"
            elif "landmark" in form and L == form["landmark"]:
                search2 = "landmark"
            else:
                search2 = L + "s"
            if search2 in form:
                for i in range(len(coordx[boroughs[b] + " and " + L])):
                    if L == "Historic District":
                        for i in range(len(coordx[boroughs[b] + " and Historic District"])):
                            for x in range(len(coordx[boroughs[b] + " and Historic District"][i])):
                                plt.fill(coordx[boroughs[b] + " and Historic District"][i][x], coordy[boroughs[b] + " and Historic District"][i][x] ,alpha= 0.25 ,color=landmarkColors[L])
                                plt.plot(coordx[boroughs[b] + " and Historic District"][i][x], coordy[boroughs[b] + " and Historic District"][i][x], linewidth=0.05 ,color="black")
                    else:
                        plt.scatter(coordx[boroughs[b] + " and " + L][i],coordy[boroughs[b] + " and " + L][i],alpha=0.5, color=landmarkColors[L])

plt.savefig("img/image.png")

print "</td>"
print "<td>"
print "<form method=\"GET\" action=\"finalproject.py\">"
print "\t<select name =\"graph\" size = \"1\">"
print "\t<option selected> Landmarks added per year </option>"
print "\t<option> Landmark total per year </option>"
print "\t</select>"
print "<br>"
print "<br>"
print "<table>"
print "<tr>"
print "\t<td class =\"righttable\"><input type=\"checkbox\" name=\"Queens\" value=\"True\"> <span style=\"color:#FF00FF;font-weight:bold\">Queens</span></td>"
print "</tr>"
print "<tr>"
print "\t<td class =\"righttable\"><input type=\"checkbox\" name=\"Brooklyn\" value=\"True\"> <span style=\"color:#0000FF;font-weight:bold\">Brooklyn</span></td>"
print "</tr>"
print "<tr>"
print "\t<td class =\"righttable\"><input type=\"checkbox\" name=\"Staten Island\" value=\"True\"> <span style=\"color:#FF0000;font-weight:bold\">Staten Island</span></td>"
print "</tr>"
print "<tr>"
print "\t<td class =\"righttable\"><input type=\"checkbox\" name=\"Manhattan\" value=\"True\"> <span style=\"color:#008000;font-weight:bold\">Manhattan</span></td>"
print "</tr>"
print "<tr>"
print "\t<td><input type=\"checkbox\" name=\"The Bronx\" value=\"True\"> <span style=\"color:#FFA500;font-weight:bold\">The Bronx</span></td>"
print "</tr>"
print "</table>"
print "<br>"
print "<br>"
print "<input type=\"submit\" name=\"refresh\" value=\"Refresh\">"
print "<br><br>"
print "*Our data source has a lot of missing landmark designation dates so the numbers may not be 100% accurate"
print "</td>"
print "</tr>"
print "<tr>"
print "<td>"
print "<img src=\"img/image.png\">"
print "</td>"
print "<td>"
print "\t<select name =\"map\" size = \"1\">"
print "\t<option selected> Borough Boundaries </option>"
print "\t<option> School District Boundaries </option>"
print "\t</select>"
print "<br>"
print "<br>"
print "<table>"
print "<tr>"
print "\t<td class =\"righttable\"><input type=\"checkbox\" name=\"Queens2\" value=\"True\"> <span style=\"color:#FF00FF;font-weight:bold\">Queens</span></td>"
print "\t<td class =\"righttable\"><input type=\"checkbox\" name=\"Historic Districts\" value=\"True\"> <span style=\"color:#808080;font-weight:bold\">Historic Districts</td>"
print "</tr>"
print "<tr>"
print "\t<td class =\"righttable\"><input type=\"checkbox\" name=\"Brooklyn2\" value=\"True\"> <span style=\"color:#0000FF;font-weight:bold\">Brooklyn</span></td>"
print "\t<td class =\"righttable\"><input type=\"checkbox\" name=\"Scenic Landmarks\" value=\"True\"> <span style=\"color:#008000;font-weight:bold\">Scenic Landmarks</span></td>"
print "</tr>"
print "<tr>"
print "\t<td class =\"righttable\"><input type=\"checkbox\" name=\"Staten Island2\" value=\"True\"> <span style=\"color:#FF0000;font-weight:bold\">Staten Island</span></td>"
print "\t<td class =\"righttable\"><input type=\"checkbox\" name=\"Interior Landmarks\" value=\"True\"> <span style=\"color:#FF0000;font-weight:bold\"> Interior Landmarks</span></td>"
print "</tr>"
print "<tr>"
print "\t<td class =\"righttable\"><input type=\"checkbox\" name=\"Manhattan2\" value=\"True\"> <span style=\"color:#008000;font-weight:bold\">Manhattan</span></td>"
print "\t<td class =\"righttable\"><input type=\"checkbox\" name=\"Individual Landmarks\" value=\"True\"> <span style=\"color:#0000FF;font-weight:bold\"> Individual Landmarks</span></td>"
print "</tr>"
print "<tr>"
print "\t<td class =\"righttable\"><input type=\"checkbox\" name=\"The Bronx2\" value=\"True\"> <span style=\"color:#FFA500;font-weight:bold\">The Bronx</span></td>"
print "\t<td class =\"righttable\"><input type=\"checkbox\" name=\"userinput\" value=\"True\"> <input type=\"text\" size=\"30\" name=\"street\" value=\"Type street name or address\"></td>"
print "</tr>"
print "<tr>"
print "<td></td>"
print "\t<td class =\"righttable\"><input type=\"checkbox\" name=\"userinput2\" value=\"True\"> <input type=\"text\" size=\"30\" name=\"landmark\" value=\"Type landmark name\"></td>"
print "</tr>"
print "</table>"
print "<br>"
print "<br>"
print "<input type=\"submit\" name=\"refresh2\" value=\"Refresh\">"
print "</form>"
print "<br><br>"
print "Note: We do not recommend checking too many boxes at once because it may take a while to plot all of the points"
print "</td>"
print "</tr>"
print "</table>"
if maps == "Borough Boundaries":
    print "<img src=\"examples/mapping.png\" usemap=\"#boroughs\">"
    print "<map name=\"boroughs\">"
    statenislandcoords = "145,465,136,456,146,441,145, 422,172, 410,182, 388,188, 383,183, 371,185, 365,186, 352,202, 340,226, 347,252, 345,300, 339,301, 357,321, 377,270, 420,245, 437,238, 433,208, 447,186, 453,145, 465"
    manhattancoords = "347,297,353,258,409,187.5,411,177.5,429, 156,445.5, 160,423,190,423.5, 214,441.5, 223.5,390, 266.5,386.5, 290,355.5, 301,347, 297"
    brooklyncoords = "364.3,393.3,362,385.3,353.3, 378.3,336, 375,328.3, 366.7,328.3, 354.3,335.7, 341.3,358.3, 327.3,346.3 318.7,369, 295.7,388, 294,398.7, 279,398.3, 270.7,410.7, 268.7,430, 279.3,433, 289,456.7, 313.7,481.3, 303.7,493.3, 328.0,487.7, 333.3,492, 343,511, 376,457.7, 400,455.7, 392.7,427, 395,427.7, 399,364.3, 405,352, 401.7,353.7, 396,364.3, 393.3"
    queenscoords = "417,426.5,530.5,393.5,583,387.5,597.5,383,597.5,377,591,369.5,580,371.5,572,368.5,571.5,362,593,351,595,342,610,340,606.5,280,626,278,632,269,631,257.5,586.5,232,581.5,245.5,565.5,231,567.5,227,559,222,557,228,548,228,547,221,525,218,517.5,222.5,510,228.5,510,221.5,490,229,501,249,488,246,494,242,480,235,483,229,465,237,447,226,429,239,424,236,419,242,398,266,431,280,456,310,482,302,495,327,490,335,499.5,342.5,510,345,513,382,513,390,418,413,417,426.5"
    bronxcoords = "431,153,444,126,489,138,494,131,507,135,509,143,548,151,572.5,161.5,571,183,557,193,531,187,549,212,554,216,512,216,505,206,501,215,491,216,489,213,482,213,480.5,228,465.8,231.8,450,219,443,223,426,215,425,191,447,162,448,157,440,158,431,153"
    printthis = "\t<area shape=\"poly\" coords=\"" + manhattancoords + "\" title=\"Manhattan\" href=\"#b1\">"
    printthis += "\t<area shape=\"poly\" coords=\"" + statenislandcoords + "\" title=\"Staten Island\" href=\"#b3\">"
    printthis += "\t<area shape=\"poly\" coords=\"" + brooklyncoords + "\" title=\"Brooklyn\" href=\"#b0\">"
    printthis += "\t<area shape=\"poly\" coords=\"" + queenscoords + "\" title=\"Queens\" href=\"#b2\">"
    printthis += "\t<area shape=\"poly\" coords=\"" + bronxcoords + "\" title=\"The Bronx\" href=\"#b4\">"
    print printthis
    print "</map>"
if maps == "School District Boundaries":
    print "<img src=\"examples/mapping2.png\" usemap=\"#districts\">"
    print "<map name=\"districts\">"
    districts = []
    districts.append("377,290,378,286,371,284,375,273,389,278,386,290,377,290")
    districts.append("374,292,354,300,347,296,354,261,370,240,389,247,405,228,416,237,391,263,389,274,390,278,373,273,370,283,377,285,374,292")
    districts.append("372,239,389,246,411,219,411,216,396,210,372,239")
    districts.append("412,220,407,226,415,233,430,235,442,225,434,217,418,217,412,220")
    districts.append("397,208,401,202,411,205,421,193,424,212,429,218,419,217,416,220,413,219,414,216,397,208")
    districts.append("401, 201,404, 196,412,183,430,157,443,162,411,205,401,201")
    districts.append("425,195,425,213,443,222,451,216,449,207,444,201,425,195")
    districts.append("452,215,450,206,40,197,484,200,488,193,507,193,511,175,518,175,519,183,527,181,533,197,551,215,533,210,515,212,515,216,510,216,505,208,500,216,490,215,482,212,480,219,452,215")
    districts.append("425,193,434,178,444,182,447,177,457,183,453,197,445,197,443,200,425,193")
    districts.append("445,161,432,156,444,128,481,137,475,143,487,144,479,162,479,185,477,187,464,179,460,182,454,178,447,176,442,181,435,176,446,166,445,161")
    districts.append("482,137,476,142,487,142,479,160,480,187,487,185,490,191,506,190,511,174,518,174,520,183,527,180,530,176,530,172,538,174,541,182,558,193,573,180,572,158,522,147,508,144,506,136,496,132,490,136,482,137")
    districts.append("452,200,465,179,476,188,487,187,484,200,470,196,459,201,452,200")
    districts.append("363,304,375,306,388,311,386,314,380,314,378,318,398,321,399,314,419,316,420,313,413,310,411,305,404,303,401,307,383,296,369,296,363,304")
    districts.append("390,294,399,279,397,272,403,268,419,273,426,279,430,284,424,291,420,297,423,302,411,303,403,301,400,306,392,300,390,294")
    districts.append("344,336,357,327,350,329,347,316,360,308,373,305,388,310,384,313,379,312,376,317,389,321,382,330,387,334,390.343.383,345,375,346,372,350,363,343,360,348,344,336")
    districts.append("421,314,415,309,413,305,427,304,437,310,439,319,421,321,421,314,")
    districts.append("391,341,389,333,384,330,390,323,398,322,400,317,418,318,419,323,434,321,434,328,413,333,416,342,403,344,403,339,398,339,397,342,391,341")
    districts.append("482,395,508,375,503,348,474,351,462,341,456,341,452,336,443,337,435,331,423,332,422,335,414,335,413,338,417,339,417,344,425,347,426,351,434,350,437,348,439,355,457,362,478,374,482,395")
    districts.append("474,350,454,336,451,316,451,307,457,315,481,305,490,328,486,334,491,342,474,350")
    districts.append("366,383,344,377,338,377,328,366,328,353,343,339,359,347,364,345,373,351,375,347,383,349,383,345,390,344,391,350,387,354,386,358,381,357,378,360,381,363,378,365,381,368,381,373,375,373,369,373,365,375,370,379,366,383")
    districts.append("407,401,404,385,403,379,399,374,404,365,395,358,388,359,385,361,380,358,378,361,383,362,380,365,383,367,382,374,378,374,374,376,370,373,367,377,372,379,366,383,371,389,366,391,366,394,356,395,353,397,355,401,363,403,375,403,407,401")
    districts.append("406,393,404,379,401,373,405,364,398,357,388,357,393,349,392,343,400,341,399,339,403,340,402,346,417,344,425,349,425,353,436,350,437,354,457,363,464,370,475,392,470,397,457,399,454,390,442,394,406,393")
    districts.append("444,337,437,330,437,322,441,321,439,312,450,316,449,320,454,334,444,337")
    districts.append("419,274,435,280,436,292,457,311,464,311,477,303,501,301,509,295,508,293,490,296,489,287,478,277,479,271,500,268,494,254,486,253,483,257,471,260,470,263,452,263,450,270,445,271,445,266,422,264,419,274")
    districts.append("509,227,510,220,495,224,490,230,497,235,499,245,504,248,496,252,503,268,514,285,536,284,541,279,538,269,544,268,554,255,548,254,548,249,554,249,547,241,552,236,559,237,566,234,563,230,567,228,564,223,558,223,560,226,548,230,546,224,528,222,525,219,517,223,514,228,509,227")
    districts.append("586,234,630,257,631,268,625,278,610,281,609,275,599,274,591,274,584,278,570,278,569,282,557,284,552,277,542,279,540,270,547,268,556,256,550,253,556,249,550,243,555,237,568,236,583,248,586,234")
    districts.append("482,305,509,297,509,293,516,296,518,304,518,309,524,309,526,315,537,313,551,311,563,321,554,328,590,345,589,350,571,357,571,368,578,372,591,369,596,376,597,384,586,387,554,390,518,396,486,407,460,414,451,415,417,426,417,416,443,407,449,409,454,408,458,405,474,405,497,394,508,393,504,385,511,372,514,348,496,344,488,333,492,328,482,305")
    districts.append("489,286,480,277,501,270,514,286,538,286,543,287,550,298,565,312,575,311,575,314,568,317,573,320,574,325,568,325,561,315,556,314,555,311,550,309,528,315,520,306,518,295,508,292,490,294,489,286")
    districts.append("569,317,578,314,576,310,568,311,558,303,550,296,544,286,540,287,540,282,553,279,556,282,555,286,571,283,571,279,585,280,589,275,598,276,609,276,609,280,604,281,606,290,607,316,606,331,608,338,595,341,594,350,582,341,555,328,564,323,568,327,573,327,575,320,569,317")
    districts.append("421,264,415,269,401,265,421,244,420,239,426,237,431,237,444,225,462,234,463,240,466,240,467,235,478,233,481,229,482,236,493,241,489,247,492,251,484,252,480,258,470,259,452,262,449,267,448,263,421,264")
    districts.append("145,465,136,456,146,441,145, 422,172, 410,182, 388,188, 383,183, 371,185, 365,186, 352,202, 340,226, 347,252, 345,300, 339,301, 357,321, 377,270, 420,245, 437,238, 433,208, 447,186, 453,145, 465")
    districts.append("427,293,421,298,439,310,450,318,451,306,436,294,427,293")
    districts.append("566,479,700,479,700,500,566,500,566,479")
    districts.append("565,500,565,530,700,530,700,500,565,500")
    for i in range(len(districts)):
        if i == 32:
            this = "\t<area shape=\"poly\" coords=\"" + districts[i] + "\" title=\"District 75\" href=\"#" + str(i) + "\">"
        elif i == 33:
            this = "\t<area shape=\"poly\" coords=\"" + districts[i] + "\" title=\"District 79\" href=\"#" + str(i) + "\">"
        else:
            this = "\t<area shape=\"poly\" coords=\"" + districts[i] + "\" title=\"District " + str(i + 1) + "\" href=\"#" + str(i) + "\">"
        print this
    print "</map><br>"
    print "*District 75 and district 79 schools are for special needs children"

file = open("csv/2012_SAT_Results.csv", "r")
SATdata = file.read()
SATdata = SATdata.split('\n')

def SATmgmt(dat):
    c = []
    for e in dat:
        r = e
        i = [r.split(',')]
        c = c + i
    c = c[1:len(c) - 1]
    #c is the dataset split by school
    schoolsInDistrict = {}
    #schoolsInDistrict is the dictionary for districts (how many schools)
    for a in c:
        m = a[0]
        b = m[0:2]
        d = str(b)
        if d in schoolsInDistrict.keys():
            schoolsInDistrict.update({d: schoolsInDistrict[d] + 1})
        else:
            schoolsInDistrict[d] = 1
    qrs = schoolsInDistrict
    districtsInBoro = {}
    #districtsInBoro is the dictionary for boroughs (how many districts)
    for a in c:
        m = a[0]
        b = m[0:3]
        d = str(b)
        B = d[2]
        if B in districtsInBoro.keys():
            if b in districtsInBoro[B]:
                districtsInBoro.update({B: districtsInBoro[B]})
            else:
                districtsInBoro.update({B: districtsInBoro[B] + [b]})
        else:
            districtsInBoro[B] = [b]
    schoolsInBoro = {}
    #schoolsInBoro is the dictionary for boroughs (how many schools)
    for a in c:
        m = a[0]
        B = str(m)[2]
        if B in schoolsInBoro.keys():
            schoolsInBoro.update({B: schoolsInBoro[B] + 1})
        else:
            schoolsInBoro[B] = 1
    for i in c:
        m = i[0]
        B = str(m)[2]
    ###########################################
    #testtakersbydistrict
    ttno = {}
    for a in c:
        m = a[0]
        if a[2] == 's':
            TT = 0
        else:
            TT = int(a[2])
        b = m[0:2]
        d = str(b)
        if d in ttno.keys():
            ttno.update({d: ttno[d] + TT})
        else:
            ttno[d] = TT
    #testtakersbyboro
    bttno = {}
    for a in c:
        m = a[0]
        if a[2] == 's':
            TT = 0
        else:
            TT = int(a[2])
        b = m[2]
        d = str(b)
        if d in bttno.keys():
            bttno.update({d: bttno[d] + TT})
        else:
            bttno[d] = TT
    #sataveragesbydistrict
    srd = {}
    smd = {}
    swd = {}
    for a in c:
        m = a[0]
        if a[2] == 's':
            TT = 0
            TTr = 0
            TTm = 0
            TTw = 0
        else:
            TT = int(a[2])
            Reading = int(a[3])
            Math = int(a[4])
            Writing = int(a[5])
            TTr = TT * Reading
            TTm = TT * Math
            TTw = TT * Writing
        b = m[0:2]
        d = str(b)
        if d in srd.keys():
            srd.update({d: srd[d] + TTr})
        else:
            srd[d] = TTr
        if d in smd.keys():
            smd.update({d: smd[d] + TTm})
        else:
            smd[d] = TTm
        if d in swd.keys():
            swd.update({d: swd[d] + TTw})
        else:
            swd[d] = TTw
    for i in srd.keys():
        srd.update({i: srd[i] / ttno[i]})
    for i in smd.keys():
        smd.update({i: smd[i] / ttno[i]})
    for i in swd.keys():
        swd.update({i: swd[i] / ttno[i]})
    #sataveragesbyboro
    srb = {}
    smb = {}
    swb = {}
    for a in c:
        m = a[0]
        if a[2] == 's':
            TT = 0
            TTr = 0
            TTm = 0
            TTw = 0
        else:
            TT = int(a[2])
            Reading = int(a[3])
            Math = int(a[4])
            Writing = int(a[5])
            TTr = TT * Reading
            TTm = TT * Math
            TTw = TT * Writing
        b = m[2]
        d = str(b)
        if d in srb.keys():
            srb.update({d: srb[d] + TTr})
        else:
            srb[d] = TTr
        if d in smb.keys():
            smb.update({d: smb[d] + TTm})
        else:
            smb[d] = TTm
        if d in swb.keys():
            swb.update({d: swb[d] + TTw})
        else:
            swb[d] = TTw
    for i in srb.keys():
        srb.update({i: srb[i] / bttno[i]})
    for i in smb.keys():
        smb.update({i: smb[i] / bttno[i]})
    for i in swb.keys():
        swb.update({i: swb[i] / bttno[i]})
    #editing schools/districts in boro
    schoolsInBoroE = {"Brooklyn": schoolsInBoro['K'], "Queens": schoolsInBoro['Q'], "Manhattan": schoolsInBoro['M'], "The Bronx": schoolsInBoro['X'], "Staten Island": schoolsInBoro['R']}
    districtsInBoroE = {"Brooklyn": districtsInBoro['K'], "Queens": districtsInBoro['Q'], "Manhattan": districtsInBoro['M'], "The Bronx": districtsInBoro['X'], "Staten Island": districtsInBoro['R']}
    srbE = {"Brooklyn": srb['K'], "Queens": srb['Q'], "Manhattan": srb['M'], "The Bronx": srb['X'], "Staten Island": srb['R']}
    smbE = {"Brooklyn": smb['K'], "Queens": smb['Q'], "Manhattan": smb['M'], "The Bronx": smb['X'], "Staten Island": smb['R']}
    swbE = {"Brooklyn": swb['K'], "Queens": swb['Q'], "Manhattan": swb['M'], "The Bronx": swb['X'], "Staten Island": swb['R']}
    bttnoE = {"Brooklyn": bttno['K'], "Queens": bttno['Q'], "Manhattan": bttno['M'], "The Bronx": bttno['X'], "Staten Island": bttno['R']}
    ###########################################
    #recap - srd, smd, swd, srb, smb, swb, ttno, bttno
    #recap - schoolsInBoroE, schoolsInDistrict, districtsInBoroE
    #TABLE TIME!!!
    #Overview of schools per boro
##    print '<table> \n<tr> <th> Borough </th> <th> Number of schools </th> </tr>'
##    for i in range(len(schoolsInBoroE)):
##        boro = schoolsInBoroE.keys()
##        chooser = boro[i]
##        print '<tr> <td>' + chooser + '</td> <td>' + str(schoolsInBoroE[chooser]) + '</td> </tr>'
##    print '</table>'
    #Overview of districts per boro
    print "<center>"
    print '<table> \n<tr> <th> Borough </th> <th> Number of districts </th> <th> Districts </th> </tr>'
    for i in range(len(districtsInBoroE)):
        boro = districtsInBoroE.keys()
        chooser = boro[i]
        print '<tr> <td>' + chooser + '</td> <td>' + str(len(districtsInBoroE[chooser])) + '</td> <td>' + " ".join(districtsInBoroE[chooser]) + '</td> </tr>'
    print '</table>'
    #SAT scores by boro 
    print '<table> \n<tr> <th> Borough </th> <th> Number of schools </th> <th> Number of test-takers </th> <th> Reading </th> <th> Math </th> <th> Writing </th>  </tr>'
    for i in range(len(srb)):
        dts = sorted(schoolsInBoroE.keys())
        chooser = dts[i]
        print '<tr ID=\"b' + str(i) + '\"> <td>' + chooser + '</td> <td>' + str(schoolsInBoroE[chooser]) + '</td> <td>' + str(bttnoE[chooser]) + '</td> <td>' + str(srbE[chooser]) + '</td> <td>' + str(smbE[chooser]) + '</td> <td>' + str(swbE[chooser]) + '</td> </tr>'
    print '</table>'

    #SAT scores by district
    print '<table> \n<tr> <th> District </th> <th> Number of schools </th> <th> Number of test-takers </th> <th> Reading </th> <th> Math </th> <th> Writing </th>  </tr>'
    for i in range(len(srd)):
        dts = sorted(schoolsInDistrict.keys())
        chooser = dts[i]
        print '<tr ID=\"' + str(i) + '\"> <td> District ' + chooser + '</td> <td>' + str(schoolsInDistrict[chooser]) + '</td> <td>' + str(ttno[chooser]) + '</td> <td>' + str(srd[chooser]) + '</td> <td>' + str(smd[chooser]) + '</td> <td>' + str(swd[chooser]) + '</td> </tr>'
    print '</table>'
    print "</center>"

SATmgmt(SATdata)
footer = """</body>
</html>"""

print footer
