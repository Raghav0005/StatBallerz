source ~db2inst2/sqllib/db2profile

# connect to database
db2 connect to cs348

# run all sql files in tests directory
for dir in $(ls tests); do
  # Make sure it's a directory
  echo $dir
#   [ -d "$dir" ] || continue

  # Define paths
  sql_file="tests/${dir}/query.sql"
  out_file="tests/${dir}/out.txt"

  echo $out_file

  # Run the SQL if it exists
  if [ -f "$sql_file" ]; then
    echo "Running $sql_file..."
    db2 -tf "$sql_file" > "$out_file"
  else
    echo "No query.sql found in $dir"
  fi
done