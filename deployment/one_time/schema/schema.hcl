table "players" {
  schema = schema.football_organiser
  column "id" {
    null           = false
    type           = int
    auto_increment = true
  }
  column "first_name" {
    null = false
    type = varchar(100)
  }
  column "surname" {
    null = false
    type = varchar(100)
  }
  column "phone_number" {
    null = false
    type = varchar(15)
  }
  primary_key {
    columns = [column.id]
  }
}

table "games" {
  schema = schema.football_organiser

  column "id" {
    null           = false
    type           = int
    auto_increment = true
  }

  column "game_name" {
    null = true
    type = tinytext
  }

  column "pitch_name" {
    null = false
    type = tinytext
  }

  column "address" {
    null = false
    type = mediumtext
  }

  column "start_time" {
    null = false
    type = timestamp
  }

  column "arrival_time" {
    null = false
    type = int
    default = 10
  }

  column "duration" {
    null = false
    type = int
    default = 60
  }

  primary_key {
    columns = [column.id]
  }
}

table "confirmed_players" {
  schema = schema.football_organiser
  column "id" {
    null           = false
    type           = int
    auto_increment = true
  }

  column "player" {
    null = false
    type = int
  }

  column "game" {
    null = false
    type = int
  }

  foreign_key "player_fk" {
    columns = [column.player]
    ref_columns = [table.players.column.id]
    on_delete = CASCADE
    on_update = NO_ACTION
  }

  foreign_key "game_fk" {
    columns = [column.game]
    ref_columns = [table.games.column.id]
    on_delete = CASCADE
    on_update = NO_ACTION
  }

  primary_key {
    columns = [column.id]
  }
}

schema "football_organiser" {
  charset = "latin1"
  collate = "latin1_swedish_ci"
}

schema "innodb" {
  charset = "latin1"
  collate = "latin1_swedish_ci"
}
