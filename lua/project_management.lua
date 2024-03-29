local function removeNonPrintableChars(str)
  return str:gsub('[%z\1-\31\127-\255]', '')
end

local function getDate()
  local dateTimeTable = os.date '*t'
  local dateTimeStr = string.format('%s/%s/%s %s:%s', dateTimeTable.day, dateTimeTable.month, dateTimeTable.year, dateTimeTable.hour, dateTimeTable.min)
  return dateTimeStr
end

local function getSelectedText()
  local selected_text = vim.fn.getline("'<", "'>")
  return (table.concat(selected_text, '\n'))
end

local function parseDateTime(text)
  local dateTimeMatch = '%d+/%d+/%d+ %d+:%d+'
  local extractionMatch = '(%d+)/(%d+)/(%d+) (%d+):(%d+)'
  local times = {}

  for i in text:gmatch(dateTimeMatch) do
    local day, month, year, hour, min = string.match(i, extractionMatch)
    if times['start'] == nil then
      times['start'] = { day = day, month = month, year = year, hour = hour, min = min }
    else
      times['end'] = { day = day, month = month, year = year, hour = hour, min = min }
    end
  end
  local hourDiff = times['end'].hour - times['start'].hour
  local minDiff = times['end'].min - times['start'].min
  vim.api.nvim_put({ hourDiff .. 'H' .. ' ' .. minDiff .. 'M', '' }, 'l', true, true)
end

vim.api.nvim_create_user_command('DateDiff', function()
  local text = getSelectedText()
  parseDateTime(text)
end, { range = true })

vim.api.nvim_create_user_command('Date', function()
  local date = getDate()
  vim.api.nvim_put({ date .. ' ' }, 'b', false, true)
end, {})

vim.api.nvim_create_user_command('NewTask', function(opts)
  local format = {
    'Task Name: ' .. opts.args,
    'Description: ',
    'Jira Link: ',
    'Relevant Commits: ',
    'Time Tracker: ',
  }
  vim.api.nvim_put(format, 'l', true, true)
end, { nargs = '*' })
