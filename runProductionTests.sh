source ~db2inst2/sqllib/db2profile

# connect to database
db2 connect to cs348

# run all sql files in tests directory
for dir in $(ls tests); do
  # Make sure it's a directory
  echo $dir
#   [ -d "$dir" ] || continue

  # Define paths
  sql_file="tests/${dir}/production/test-production.sql"
  out_file="tests/${dir}/production/test-production.out"

  echo $out_file

  # Run the SQL if it exists
  if [ -f "$sql_file" ]; then
    echo "Running $sql_file..."
    db2 -tf "$sql_file" > "$out_file"
  else
    echo "No test-production.sql found in $dir"
  fi
done