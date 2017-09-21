default do
  foo "bar"
  bar "baz"
end

production do
  env "foo"
end

dev_int do
  bar "baz"
end

test do
  foo "bar"
  bool_true true
  bool_false false
  array 1, 2, 3, 4
  array_alt [1, 2, 3, 4]
  from_env ENV['FIGLEAF_TEST_FOO']
end
