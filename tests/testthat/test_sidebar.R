library(testthat)
library(shiny)
library(bs4Dash)

test_that("Insert_User_Sidebar returns a valid sidebar menu structure", {
  # Call the function
  result <- Insert_User_Sidebar()
  
  # Check if the result is a shiny.tag with a <ul> root
  expect_s3_class(result, "shiny.tag")
  expect_equal(result$name, "ul")
  expect_match(result$attribs$class, "nav")
  expect_match(result$attribs$class, "sidebar")
  
  # Extract children (2 elements: a list of <li> items and a <div>)
  children <- result$children
  expect_equal(length(children), 2)
  
  # --- First child: List of <li> items (Home, Dataset, Workflow) ---
  li_items <- children[[1]]
  expect_true(is.list(li_items))
  expect_equal(length(li_items), 3)  # 3 <li> items
  
  # --- Test Home menu item (first <li>) ---
  home_item <- li_items[[1]]
  expect_s3_class(home_item, "shiny.tag")
  expect_equal(home_item$name, "li")
  expect_true("nav-item" %in% home_item$attribs$class)
  
  # Check the <a> tag inside Home item
  home_link <- home_item$children[[1]]
  expect_s3_class(home_link, "shiny.tag")
  expect_equal(home_link$name, "a")
  expect_true("nav-link" %in% home_link$attribs$class)
  expect_equal(home_link$attribs$`data-value`, "Home")
  
  # Check the <p> tag with the "Home" text
  home_p_tag <- home_link$children[[2]]
  expect_s3_class(home_p_tag, "shiny.tag")
  expect_equal(home_p_tag$name, "p")
  
  home_text_p_tag <- home_p_tag$children[[1]]
  expect_s3_class(home_text_p_tag, "shiny.tag")
  expect_equal(home_text_p_tag$name, "p")
  expect_true("sidebarMenuItem" %in% home_text_p_tag$attribs$class)
  expect_equal(home_text_p_tag$children[[1]], "Home")
  
  # --- Test Dataset menu item (second <li>) ---
  dataset_item <- li_items[[2]]
  expect_s3_class(dataset_item, "shiny.tag")
  expect_equal(dataset_item$name, "li")
  expect_match(dataset_item$attribs$class, "nav-item")
  expect_match(dataset_item$attribs$class, "has-treeview")
  
  # Check the <a> tag inside Dataset item
  dataset_link <- dataset_item$children[[1]]
  expect_s3_class(dataset_link, "shiny.tag")
  expect_equal(dataset_link$name, "a")
  expect_true("nav-link" %in% dataset_link$attribs$class)
  
  # Check the <p> tag with the "Dataset" text
  dataset_p_tag <- dataset_link$children[[2]]
  expect_s3_class(dataset_p_tag, "shiny.tag")
  expect_equal(dataset_p_tag$name, "p")
  
  dataset_text_p_tag <- dataset_p_tag$children[[1]]
  expect_s3_class(dataset_text_p_tag, "shiny.tag")
  expect_equal(dataset_text_p_tag$name, "p")
  expect_true("sidebarMenuItem" %in% dataset_text_p_tag$attribs$class)
  expect_equal(dataset_text_p_tag$children[[1]], "Dataset")
  
  # Check the <ul> submenu for Dataset
  dataset_submenu <- dataset_item$children[[2]]
  expect_s3_class(dataset_submenu, "shiny.tag")
  expect_equal(dataset_submenu$name, "ul")
  expect_match(dataset_submenu$attribs$class, "nav")
  expect_match(dataset_submenu$attribs$class, "nav-treeview")
  
  # Extract sub-items (Open file, Import, Save As)
  dataset_sub_items <- dataset_submenu$children
  expect_equal(length(dataset_sub_items), 2)
  
  # Test first sub-item (Open file)
  open_file_item <- dataset_sub_items[[1]][[1]]
  expect_s3_class(open_file_item, "shiny.tag")
  expect_equal(open_file_item$name, "li")
  expect_match(open_file_item$attribs$class, "nav-item")
  
  open_file_link <- open_file_item$children[[1]]
  expect_s3_class(open_file_link, "shiny.tag")
  expect_equal(open_file_link$name, "a")
  expect_equal(open_file_link$attribs$`data-value`, "openDataset")
  
  open_file_p_tag <- open_file_link$children[[2]]
  expect_s3_class(open_file_p_tag, "shiny.tag")
  expect_equal(open_file_p_tag$name, "p")
  
  open_file_text_p_tag <- open_file_p_tag$children[[1]]
  expect_s3_class(open_file_text_p_tag, "shiny.tag")
  expect_equal(open_file_text_p_tag$name, "p")
  expect_true("sidebarMenuSubItem" %in% open_file_text_p_tag$attribs$class)
  expect_equal(open_file_text_p_tag$children[[1]], "Open file")
  
  # Test second sub-item (Import)
  import_item <- dataset_sub_items[[1]][[2]]
  expect_s3_class(import_item, "shiny.tag")
  expect_equal(import_item$name, "li")
  
  import_link <- import_item$children[[1]]
  expect_equal(import_link$attribs$`data-value`, "convertDataset")
  
  import_text_p_tag <- import_link$children[[2]]$children[[1]]
  expect_true("sidebarMenuSubItem" %in% import_text_p_tag$attribs$class)
  expect_equal(import_text_p_tag$children[[1]], "Import")
  
  # Test third sub-item (Save As)
  save_as_item <- dataset_sub_items[[1]][[3]]
  expect_s3_class(save_as_item, "shiny.tag")
  expect_equal(save_as_item$name, "li")
  
  save_as_link <- save_as_item$children[[1]]
  expect_equal(save_as_link$attribs$`data-value`, "SaveAs")
  
  save_as_text_p_tag <- save_as_link$children[[2]]$children[[1]]
  expect_true("sidebarMenuSubItem" %in% save_as_text_p_tag$attribs$class)
  expect_equal(save_as_text_p_tag$children[[1]], "Save As")
  
  # --- Test Workflow menu item (third <li>) ---
  workflow_item <- li_items[[3]]
  expect_s3_class(workflow_item, "shiny.tag")
  expect_equal(workflow_item$name, "li")
  expect_match(workflow_item$attribs$class, "nav-item")
  expect_match(workflow_item$attribs$class, "has-treeview")
  
  # Check the <a> tag inside Workflow item
  workflow_link <- workflow_item$children[[1]]
  expect_s3_class(workflow_link, "shiny.tag")
  expect_equal(workflow_link$name, "a")
  expect_true("nav-link" %in% workflow_link$attribs$class)
  
  # Check the <p> tag with the "Workflow" text
  workflow_p_tag <- workflow_link$children[[2]]
  workflow_text_p_tag <- workflow_p_tag$children[[1]]
  expect_true("sidebarMenuItem" %in% workflow_text_p_tag$attribs$class)
  expect_equal(workflow_text_p_tag$children[[1]], "Workflow")
  
  # Check the <ul> submenu for Workflow
  workflow_submenu <- workflow_item$children[[2]]
  expect_s3_class(workflow_submenu, "shiny.tag")
  expect_equal(workflow_submenu$name, "ul")
  expect_match(workflow_submenu$attribs$class, "nav")
  expect_match(workflow_submenu$attribs$class, "nav-treeview")
  
  # Extract sub-items (Run, Manual, FAQ, Release Notes)
  workflow_sub_items <- workflow_submenu$children
  expect_equal(length(workflow_sub_items), 2)
  
  # Test first sub-item (Run)
  run_item <- workflow_sub_items[[1]][[1]]
  run_link <- run_item$children[[1]]
  expect_equal(run_link$attribs$`data-value`, "workflow")
  run_text_p_tag <- run_link$children[[2]]$children[[1]]
  expect_true("sidebarMenuSubItem" %in% run_text_p_tag$attribs$class)
  expect_equal(run_text_p_tag$children[[1]], "Run")
  
  # Test second sub-item (Manual)
  manual_item <- workflow_sub_items[[1]][[2]]
  manual_link <- manual_item$children[[1]]
  expect_equal(manual_link$attribs$`data-value`, "Manual")
  manual_text_p_tag <- manual_link$children[[2]]$children[[1]]
  expect_true("sidebarMenuSubItem" %in% manual_text_p_tag$attribs$class)
  expect_equal(manual_text_p_tag$children[[1]], "Manual")
  
  # Test third sub-item (FAQ)
  faq_item <- workflow_sub_items[[1]][[3]]
  faq_link <- faq_item$children[[1]]
  expect_equal(faq_link$attribs$`data-value`, "faq")
  faq_text_p_tag <- faq_link$children[[2]]$children[[1]]
  expect_true("sidebarMenuSubItem" %in% faq_text_p_tag$attribs$class)
  expect_equal(faq_text_p_tag$children[[1]], "FAQ")
  
  # Test fourth sub-item (Release Notes)
  release_notes_item <- workflow_sub_items[[1]][[4]]
  release_notes_link <- release_notes_item$children[[1]]
  expect_equal(release_notes_link$attribs$`data-value`, "releaseNotes")
  release_notes_text_p_tag <- release_notes_link$children[[2]]$children[[1]]
  expect_true("sidebarMenuSubItem" %in% release_notes_text_p_tag$attribs$class)
  expect_equal(release_notes_text_p_tag$children[[1]], "Release Notes")
  
  # --- Second child: <div> for tabs ---
  tabs_div <- children[[2]]
  expect_s3_class(tabs_div, "shiny.tag")
  expect_equal(tabs_div$name, "div")
  expect_true("sidebarMenuSelectedTabItem" %in% tabs_div$attribs$class)
  expect_equal(tabs_div$attribs$`data-value`, "null")
})
