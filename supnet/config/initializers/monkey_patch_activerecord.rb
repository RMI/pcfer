class ActiveRecord::Tasks::PostgreSQLDatabaseTasks
  def drop
    establish_master_connection
    connection.execute "DROP DATABASE IF EXISTS \"#{db_config.database}\" WITH (FORCE)"
  end
end