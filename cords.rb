s = Roo::Excelx.new("cords.xlsx")         # loads an Excel Spreadsheet for Excel .xlsx files
s.default_sheet = s.sheets.first

districts = []

((s.first_row+1)..s.last_row).each do |row_num|
  districts << [s.cell(row_num, 'H'), s.cell(row_num, 'K')]
end

districts.uniq.each do |district|
  d = District.new
  d.en_name = district[0]
  d.ar_name = district[1]
  d.save
end

((s.first_row+1)..s.last_row).each do |row_num|
  c = Checkpoint.new
  c.en_name = s.cell(row_num, 'G')
  c.en_description = s.cell(row_num, 'I')
  c.ar_name = s.cell(row_num, 'J')
  c.ar_description = s.cell(row_num, 'L')
  c.lng = s.cell(row_num, 'M')
  c.lat = s.cell(row_num, 'N')
  c.district_id = District.find_by(en_name: s.cell(row_num, 'H')).id
  c.open = true
  c.save
end