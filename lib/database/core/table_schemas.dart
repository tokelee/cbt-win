class TableSchemas {
  // 1. Users Table
  static const String userTable = """
    CREATE TABLE IF NOT EXISTS users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      username TEXT NOT NULL UNIQUE,
      first_name TEXT,
      last_name TEXT,
      created_at TEXT,
      updated_at TEXT
    );
  """;

  // 2. Subjects Table
  static const String subjectTable = """
    CREATE TABLE IF NOT EXISTS subjects (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      subject TEXT NOT NULL UNIQUE,
      department TEXT,
      slug TEXT,
      created_at TEXT
    );
  """;

  // 3. Topics Table (Linked to Subjects)
  static const String topicsTable = """
    CREATE TABLE IF NOT EXISTS topics (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      topic TEXT NOT NULL UNIQUE,
      subject_id INTEGER NOT NULL, 
      created_at TEXT,
      FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE CASCADE
    );
  """;

  static const String sectionTable = """
  CREATE TABLE IF NOT EXISTS sections (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    unique_id TEXT UNIQUE, -- e.g., 'math_2025_sec_a'
    subject_id INTEGER,
    instruction TEXT,             
    section_label TEXT,            -- e.g., 'Section A' or 'Comprehension'
    created_at TEXT,
    FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE CASCADE
  );
""";

  // 4. Questions Table (Linked to Subjects)
  static const String questionTable = """
    CREATE TABLE IF NOT EXISTS questions (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      unique_id TEXT UNIQUE,
      subject_id INTEGER, 
      year TEXT NOT NULL,
      question TEXT NOT NULL,
      option_a TEXT, option_b TEXT, option_c TEXT, option_d TEXT,
      answer TEXT,
      topic_id INTEGER,
      mark INTEGER,
      type TEXT,
      is_objective INTEGER DEFAULT 1,
      is_deleted INTEGER DEFAULT 0,
      image_name TEXT,
      explanation TEXT,
      section_id INTEGER NOT NULL,
      created_at TEXT,
      updated_at TEXT,
      FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE NULL,
      FOREIGN KEY (topic_id) REFERENCES topics (id) ON DELETE SET NULL,
      FOREIGN KEY (section_id) REFERENCES sections (id) ON DELETE SET NULL
    );
  """;

  // 5. Result History Table (Linked to Users)
  static const String jambResultHistoryTable = """
    CREATE TABLE IF NOT EXISTS jambResultHistory (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER,
      subject_and_score TEXT NOT NULL,
      total_subject TEXT NOT NULL,
      score TEXT NOT NULL,
      created_at TEXT,
      FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
    );
  """;

  static const String ssceResultHistoryTable = """
 CREATE TABLE IF NOT EXISTS ssceResultHistory (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    subjectAndScore TEXT NOT NULL,
    user_id INTEGER NOT NULL,
    totalSubject TEXT NOT NULL,
    score TEXT,
    exam_type TEXT NOT NULL,
    created_at TEXT,
    FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
  )
  """;
}
