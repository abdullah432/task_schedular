class Note {
  int _id;
  String _title;
  String _location;
  String _description;
  String _startdate;
  String _enddate;
  String _privacy;
  String _starttime;
  String _duetime;

  Note(this._title, this._startdate, this._enddate,
      [this._location, this._description, this._privacy, this._starttime, this._duetime]);
  Note.withID(this._title, this._startdate, this._enddate,
      [this._location, this._description, this._privacy, this._starttime, this._duetime]);

  int get id => this._id;
  String get title => this._title;
  String get location => this._location;
  String get description => this._description;
  String get privacy => this._privacy;
  String get startdate => this._startdate;
  String get enddate => this._enddate;
  String get starttime => this._starttime;
  String get duetime => this._duetime;

  set title(String newTitle) {
    if (title.length <= 255) this._title = newTitle;
  }

  set location(String newLocation) {
    if (location.length <= 255) this._location = newLocation;
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) this._description = newDescription;
  }

  set privacy(String newPrivacy) {
    this._privacy = newPrivacy;
  }

  set startDate(String newStartDate) {
    this._startdate = newStartDate;
  }

  set endDate(String newEndDate) {
    this._enddate = newEndDate;
  }

  set setStartTime(String newtime) {
    this._starttime = newtime;
  }

    set setDueTime(String newtime) {
    this._duetime = newtime;
  }

  //SQLFlite only get and return value in form of map

  //Convert Note object to Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) map['id'] = _id;

    map['title'] = _title;
    map['location'] = _location;
    map['description'] = _description;
    map['privacy'] = _privacy;
    map['startdate'] = _startdate;
    map['enddate'] = _enddate;
    map['starttime'] = _starttime;
    map['duetime'] = _duetime;

    return map;
  }

  //Convert Map object to Note object
  Note.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _location = map['location'];
    _description = map['description'];
    _privacy = map['privacy'];
    _startdate = map['startdate'];
    _enddate = map['enddate'];
    _starttime = map['starttime'];
    _duetime = map['duetime'];
  }
}
