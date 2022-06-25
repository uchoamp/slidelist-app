class Tables {
  static const String cards = """
    CREATE TABLE [cards](
        [id] INTEGER PRIMARY KEY AUTOINCREMENT,
        [name] VARCHAR(255) NOT NULL,
        [confirmed] BOOLEAN NOT NULL
    );
  """;

  static const String initialState = """
    CREATE TABLE [initial_state](
        [card_id] INTEGER NOT NULL
    );
  """;

  static const String items = """
    CREATE TABLE [items](
        [id] INTEGER PRIMARY KEY AUTOINCREMENT,
        [card_id] INTEGER NOT NULL,
        [value] VARCHAR(255) NOT NULL,
        [confirmed] BOOLEAN NOT NULL
    );
  """;
}
