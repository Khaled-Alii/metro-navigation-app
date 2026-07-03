import 'package:metro/model/loc_station.dart';

final Map<String, List<String>> lines = {
  //  LINE 1
  'helwan': ['ain helwan'],
  'ain helwan': ['helwan', 'helwan university'],
  'helwan university': ['ain helwan', 'wadi hof'],
  'wadi hof': ['helwan university', 'hadayek helwan'],
  'hadayek helwan': ['wadi hof', 'el-maasara'],
  'el-maasara': ['hadayek helwan', 'tora el-asmant'],
  'tora el-asmant': ['el-maasara', 'kozzika'],
  'kozzika': ['tora el-asmant', 'tora el-balad'],
  'tora el-balad': ['kozzika', 'sakanat el-maadi'],
  'sakanat el-maadi': ['tora el-balad', 'maadi'],
  'maadi': ['sakanat el-maadi', 'hadayek el-maadi'],
  'hadayek el-maadi': ['maadi', 'dar el-salam'],
  'dar el-salam': ['hadayek el-maadi', 'el-zahraa'],
  'el-zahraa': ['dar el-salam', 'mar girgis'],
  'mar girgis': ['el-zahraa', 'el-malek el-saleh'],
  'el-malek el-saleh': ['mar girgis', 'al-sayeda zeinab'],
  'al-sayeda zeinab': ['el-malek el-saleh', 'saad zaghloul'],
  'saad zaghloul': ['al-sayeda zeinab', 'sadat'],
  'sadat': ['saad zaghloul', 'nasser', 'opera', 'naguib'],
  'nasser': ['sadat', 'orabi', 'attaba', 'maspero'],
  'orabi': ['nasser', 'al-shohadaa'],
  'al-shohadaa': ['orabi', 'ghamra', 'attaba', 'massara'],
  'ghamra': ['al-shohadaa', 'el-demerdash'],
  'el-demerdash': ['ghamra', 'manshiet el-sadr'],
  'manshiet el-sadr': ['el-demerdash', 'kobri el-qobba'],
  'kobri el-qobba': ['manshiet el-sadr', 'hammamat el-qobba'],
  'hammamat el-qobba': ['kobri el-qobba', 'saray el-qobba'],
  'saray el-qobba': ['hammamat el-qobba', 'hadayek el-zaitoun'],
  'hadayek el-zaitoun': ['saray el-qobba', 'helmeyet el-zaitoun'],
  'helmeyet el-zaitoun': ['hadayek el-zaitoun', 'el-matareyya'],
  'el-matareyya': ['helmeyet el-zaitoun', 'ain shams'],
  'ain shams': ['el-matareyya', 'ezbet el-nakhl'],
  'ezbet el-nakhl': ['ain shams', 'el-marg'],
  'el-marg': ['ezbet el-nakhl', 'new el-marg'],
  'new el-marg': ['el-marg'],

  //  LINE 2
  'el monib': ['sakiat mekki'],
  'sakiat mekki': ['el monib', 'omm el-masryeen'],
  'omm el-masryeen': ['sakiat mekki', 'giza'],
  'giza': ['omm el-masryeen', 'faisal'],
  'faisal': ['giza', 'cairo university'],
  'cairo university': ['faisal', 'bohooth', 'boulak el-dakrour'],
  'bohooth': ['cairo university', 'dokki'],
  'dokki': ['bohooth', 'opera'],
  'opera': ['dokki', 'sadat'],
  'naguib': ['sadat', 'attaba'],
  'attaba': ['naguib', 'al-shohadaa', 'bab el-shaariya', 'nasser'],
  'massara': ['al-shohadaa', 'rod el-farag'],
  'rod el-farag': ['massara', 'sainte teresa'],
  'sainte teresa': ['rod el-farag', 'khalafawy'],
  'khalafawy': ['sainte teresa', 'mezallat'],
  'mezallat': ['khalafawy', 'koleyet el-zeraa'],
  'koleyet el-zeraa': ['mezallat', 'shubra el-kheima'],
  'shubra el-kheima': ['koleyet el-zeraa'],

  //  LINE 3
  'adly mansour': ['el haykestep'],
  'el haykestep': ['adly mansour', 'omar ibn el khattab'],
  'omar ibn el khattab': ['el haykestep', 'qubaa'],
  'qubaa': ['omar ibn el khattab', 'hesham barakat'],
  'hesham barakat': ['qubaa', 'el nozha'],
  'el nozha': ['hesham barakat', 'el shams club'],
  'el shams club': ['el nozha', 'alf masken'],
  'alf masken': ['el shams club', 'heliopolis'],
  'heliopolis': ['alf masken', 'haroun'],
  'haroun': ['heliopolis', 'al-ahram'],
  'al-ahram': ['haroun', 'koleyet el-banat'],
  'koleyet el-banat': ['al-ahram', 'stadium'],
  'stadium': ['koleyet el-banat', 'fair zone'],
  'fair zone': ['stadium', 'abbassiya'],
  'abbassiya': ['fair zone', 'abdou pasha'],
  'abdou pasha': ['abbassiya', 'el-geish'],
  'el-geish': ['abdou pasha', 'bab el-shaariya'],
  'bab el-shaariya': ['el-geish', 'attaba'],
  'maspero': ['nasser', 'safaa hegazy'],
  'safaa hegazy': ['maspero', 'kit-kat'],
  'kit-kat': ['safaa hegazy', 'sudan', 'tawfikia'],

  //  SPLIT
  'sudan': ['kit-kat', 'imbaba'],
  'imbaba': ['sudan', 'el-bohy'],
  'el-bohy': ['imbaba', 'el-qawmia'],
  'el-qawmia': ['el-bohy', 'ring road'],
  'ring road': ['el-qawmia', 'rod el-farag corridor'],
  'rod el-farag corridor': ['ring road'],

  'tawfikia': ['kit-kat', 'wadi el nile'],
  'wadi el nile': ['tawfikia', 'gamat el dowel'],
  'gamat el dowel': ['wadi el nile', 'boulak el-dakrour'],
  'boulak el-dakrour': ['gamat el dowel', 'cairo university'],
};
final List<LocStation> locStations = [
  // --- LINE 1 ---
  LocStation(station: "Helwan", latitude: 29.848889, longitude: 31.334167),
  LocStation(station: "Ain Helwan", latitude: 29.862778, longitude: 31.325000),
  LocStation(
    station: "Helwan University",
    latitude: 29.868889,
    longitude: 31.320278,
  ),
  LocStation(station: "Wadi Hof", latitude: 29.879444, longitude: 31.313333),
  LocStation(
    station: "Hadayek Helwan",
    latitude: 29.897222,
    longitude: 31.304167,
  ),
  LocStation(station: "El-Maasara", latitude: 29.906111, longitude: 31.299722),
  LocStation(
    station: "Tora El-Asmant",
    latitude: 29.925833,
    longitude: 31.287778,
  ),
  LocStation(station: "Kozzika", latitude: 29.936111, longitude: 31.281667),
  LocStation(
    station: "Tora El-Balad",
    latitude: 29.946389,
    longitude: 31.273611,
  ),
  LocStation(
    station: "Sakanat El-Maadi",
    latitude: 29.952778,
    longitude: 31.263333,
  ),
  LocStation(station: "Maadi", latitude: 29.959722, longitude: 31.258056),
  LocStation(
    station: "Hadayek El-Maadi",
    latitude: 29.970000,
    longitude: 31.250556,
  ),
  LocStation(
    station: "Dar El-Salam",
    latitude: 29.981944,
    longitude: 31.242222,
  ),
  LocStation(station: "El-Zahraa'", latitude: 29.995278, longitude: 31.231667),
  LocStation(station: "Mar Girgis", latitude: 30.005833, longitude: 31.229444),
  LocStation(
    station: "El-Malek El-Saleh",
    latitude: 30.016944,
    longitude: 31.230833,
  ),
  LocStation(
    station: "Al-Sayeda Zeinab",
    latitude: 30.029167,
    longitude: 31.235278,
  ),
  LocStation(
    station: "Saad Zaghloul",
    latitude: 30.036667,
    longitude: 31.238056,
  ),
  LocStation(station: "Sadat", latitude: 30.044444, longitude: 31.235556),
  LocStation(station: "Nasser", latitude: 30.053611, longitude: 31.238889),
  LocStation(station: "Orabi", latitude: 30.057500, longitude: 31.242500),
  LocStation(station: "Al-Shohadaa", latitude: 30.061944, longitude: 31.246111),
  LocStation(station: "Ghamra", latitude: 30.068889, longitude: 31.264722),
  LocStation(
    station: "El-Demerdash",
    latitude: 30.077222,
    longitude: 31.277778,
  ),
  LocStation(
    station: "Manshiet El-Sadr",
    latitude: 30.082222,
    longitude: 31.287778,
  ),
  LocStation(
    station: "Kobri El-Qobba",
    latitude: 30.086944,
    longitude: 31.293889,
  ),
  LocStation(
    station: "Hammamat El-Qobba",
    latitude: 30.090278,
    longitude: 31.298056,
  ),
  LocStation(
    station: "Saray El-Qobba",
    latitude: 30.098056,
    longitude: 31.304722,
  ),
  LocStation(
    station: "Hadayeq El-Zaitoun",
    latitude: 30.105278,
    longitude: 31.310000,
  ),
  LocStation(
    station: "Helmeyet El-Zaitoun",
    latitude: 30.114444,
    longitude: 31.313889,
  ),
  LocStation(
    station: "El-Matareyya",
    latitude: 30.121389,
    longitude: 31.313889,
  ),
  LocStation(station: "Ain Shams", latitude: 30.131111, longitude: 31.319167),
  LocStation(
    station: "Ezbet El-Nakhl",
    latitude: 30.139167,
    longitude: 31.324444,
  ),
  LocStation(station: "El-Marg", latitude: 30.152222, longitude: 31.335556),
  LocStation(station: "New El-Marg", latitude: 30.163333, longitude: 31.338333),

  // --- LINE 2 ---
  LocStation(station: "El-Mounib", latitude: 29.981389, longitude: 31.211944),
  LocStation(
    station: "Sakiat Mekky",
    latitude: 29.995556,
    longitude: 31.208611,
  ),
  LocStation(
    station: "Omm El-Masryeen",
    latitude: 30.005278,
    longitude: 31.208056,
  ),
  LocStation(station: "El Giza", latitude: 30.010556, longitude: 31.206944),
  LocStation(station: "Faisal", latitude: 30.017222, longitude: 31.203889),
  LocStation(
    station: "Cairo University",
    latitude: 30.026111,
    longitude: 31.201111,
  ),
  LocStation(station: "El Bohoth", latitude: 30.035833, longitude: 31.200278),
  LocStation(station: "Dokki", latitude: 30.038333, longitude: 31.211944),
  LocStation(station: "Opera", latitude: 30.041944, longitude: 31.225278),
  LocStation(station: "Sadat", latitude: 30.044444, longitude: 31.235556),
  LocStation(
    station: "Mohamed Naguib",
    latitude: 30.045278,
    longitude: 31.244167,
  ),
  LocStation(station: "Attaba", latitude: 30.052500, longitude: 31.246944),
  LocStation(station: "Al-Shohadaa", latitude: 30.061944, longitude: 31.246111),
  LocStation(station: "Masarra", latitude: 30.071111, longitude: 31.245000),
  LocStation(
    station: "Road El-Farag",
    latitude: 30.080556,
    longitude: 31.245556,
  ),
  LocStation(station: "St. Teresa", latitude: 30.088333, longitude: 31.245556),
  LocStation(station: "Khalafawy", latitude: 30.098056, longitude: 31.245278),
  LocStation(station: "Mezallat", latitude: 30.105000, longitude: 31.246667),
  LocStation(
    station: "Kolleyyet El-Zeraa",
    latitude: 30.113889,
    longitude: 31.248611,
  ),
  LocStation(
    station: "Shubra El-Kheima",
    latitude: 30.122500,
    longitude: 31.244722,
  ),

  // --- LINE 3 ---
  LocStation(
    station: "Adly Mansour",
    latitude: 30.146944,
    longitude: 31.421389,
  ),
  LocStation(
    station: "El Haykestep",
    latitude: 30.143889,
    longitude: 31.404722,
  ),
  LocStation(
    station: "Omar Ibn El-Khattab",
    latitude: 30.140556,
    longitude: 31.394167,
  ),
  LocStation(station: "Qobaa", latitude: 30.134722, longitude: 31.383889),
  LocStation(
    station: "Hesham Barakat",
    latitude: 30.131111,
    longitude: 31.372778,
  ),
  LocStation(station: "El-Nozha", latitude: 30.128333, longitude: 31.360000),
  LocStation(
    station: "Nadi El-Shams",
    latitude: 30.122222,
    longitude: 31.343889,
  ),
  LocStation(station: "Alf Maskan", latitude: 30.118056, longitude: 31.339722),
  LocStation(
    station: "Heliopolis Square",
    latitude: 30.108056,
    longitude: 31.338056,
  ),
  LocStation(station: "Haroun", latitude: 30.101111, longitude: 31.332778),
  LocStation(station: "Al-Ahram", latitude: 30.091389, longitude: 31.326389),
  LocStation(
    station: "Koleyet El-Banat",
    latitude: 30.083611,
    longitude: 31.328889,
  ),
  LocStation(station: "Stadium", latitude: 30.073056, longitude: 31.317500),
  LocStation(station: "Fair Zone", latitude: 30.073333, longitude: 31.301111),
  LocStation(station: "Abbassia", latitude: 30.069722, longitude: 31.280833),
  LocStation(station: "Abdou Pasha", latitude: 30.064722, longitude: 31.274722),
  LocStation(station: "El Geish", latitude: 30.061944, longitude: 31.266944),
  LocStation(
    station: "Bab El Shaaria",
    latitude: 30.053889,
    longitude: 31.256111,
  ),
  LocStation(station: "Attaba", latitude: 30.052500, longitude: 31.246944),
  LocStation(station: "Nasser", latitude: 30.053611, longitude: 31.238889),
  LocStation(station: "Maspero", latitude: 30.055556, longitude: 31.232222),
  LocStation(
    station: "Safaa Hegazy",
    latitude: 30.062500,
    longitude: 31.222500,
  ),
  LocStation(station: "Kit Kat", latitude: 30.066667, longitude: 31.213056),
  LocStation(station: "Sudan", latitude: 30.069722, longitude: 31.205278),
  LocStation(station: "Imbaba", latitude: 30.075833, longitude: 31.207500),
  LocStation(station: "El-Bohy", latitude: 30.082222, longitude: 31.210556),
  LocStation(station: "El-Qawmia", latitude: 30.093333, longitude: 31.208889),
  LocStation(station: "Ring Road", latitude: 30.096389, longitude: 31.199722),
  LocStation(
    station: "Rod al-Farag Corridor",
    latitude: 30.101944,
    longitude: 31.184167,
  ),
  LocStation(station: "Tawfikia", latitude: 30.065278, longitude: 31.202500),
  LocStation(
    station: "Wadi El Nile",
    latitude: 30.058333,
    longitude: 31.201111,
  ),
  LocStation(
    station: "Gamat El Dowal",
    latitude: 30.050833,
    longitude: 31.199722,
  ),
  LocStation(
    station: "Boulak El Dakrour",
    latitude: 30.036111,
    longitude: 31.196389,
  ),
  LocStation(
    station: "Cairo University",
    latitude: 30.026111,
    longitude: 31.201111,
  ),
];

List<List<String>> result = [];

void dfsAll(Map<String, List<String>> graph, String start, String goal) {
  dfs(graph, start, [], <String>{}, goal);
}

void dfs(
  Map<String, List<String>> graph,
  String current,
  List<String> path,
  Set<String> visited,
  String goal,
) {
  path.add(current);
  visited.add(current);

  if (current == goal) {
    result.add(List.from(path));
  } else {
    for (final next in graph[current] ?? []) {
      if (!visited.contains(next)) {
        dfs(graph, next, path, visited, goal);
      }
    }
  }

  path.removeLast();
  visited.remove(current);
}

//-----------------------------------------find transfer stations-------------------------
List<String> findTransStation(List<String> path) {
  if (path.length < 3) {
    return [];
  }
  final sharedStations = {
    'sadat',
    'cairo university',
    'nasser',
    'attaba',
    'al-shohadaa',
  };
  final sharedLineStations = {
    {'sadat', 'nasser', 'orabi'},
    {'attaba', 'nasser', 'maspero'},
    {'opera', 'sadat', 'naguib'},
    {'saad zaghloul', 'sadat', 'nasser'},
    {'orabi', 'al-shohadaa', 'ghamra'},
    {'attaba', 'al-shohadaa', 'massara'},
    {'naguib', 'attaba', 'al-shohadaa'},
    {'nasser', 'attaba', 'bab el-shaariya'},
    {'cairo university', 'faisal', 'bohooth'},
  };
  final transN = <String>[];
  for (int k = 1; k < path.length - 1; k++) {
    bool flag = true;
    if (sharedStations.contains(path[k])) {
      try {
        var list = <String>{};
        list = {path[k - 1], path[k], path[k + 1]};
        for (var set in sharedLineStations) {
          if (set.containsAll(list)) {
            flag = false;
            break;
          }
        }
        if (flag) {
          transN.add(path[k]);
        }
      } on RangeError {
        print('Error on range');
      }
    }
  }
  return transN;
}
