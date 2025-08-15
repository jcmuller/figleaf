default do
  leaf1 "default1"
  root1(leaf11: "default2")
  root2(
    leaf21: "default3",
    root21: {
      leaf211: "default4",
      root211: {
        leaf2111: "default5"
      }
    }
  )
end

unused do
  root1(leaf11: "unused11")
  root2(root21: {root21: {leaf211: "unused2"}})
end

overridden do
  leaf2 "overridden1"
  root1(leaf11: "overridden2")

  root2(
    leaf22: "overridden3",
    root21: {
      leaf211: "overridden4",
      root211: {
        leaf2112: "overridden5"
      }
    }
  )
end
