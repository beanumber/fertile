context("projects")

test_that("project checking works", {

  # noob
  dir <- test_path("project_noob")
  test_dir <- sandbox(dir)

  seed_old <- .Random.seed
  expect_gt(nrow(x <- check(dir)), 1)

  expect_true(has_proj_root(test_dir)$state)
  expect_false(has_readme(test_dir)$state)
  expect_true(has_tidy_media(test_dir)$state)
  expect_true(has_tidy_images(test_dir)$state)
  expect_true(has_tidy_code(test_dir)$state)
  expect_true(has_tidy_raw_data(test_dir)$state)
  expect_true(has_tidy_data(test_dir)$state)
  expect_true(has_tidy_scripts(test_dir)$state)
  expect_true(has_no_absolute_paths(test_dir)$state)
  expect_true(has_only_portable_paths(test_dir)$state)
  expect_true(has_no_randomness(test_dir, seed_old)$state)

  expect_warning(proj_analyze_files(test_dir), "README")
  expect_warning(x <- proj_test(test_dir), "README")

  expect_length(dir_ls(tempdir(), regexp = "simple.html$"), 1)
  expect_equal(nrow(x$packages), 2)
  # .Rbuildignore says to ignore .Rproj files!
  expect_equal(nrow(dplyr::filter(x$files, ext != "Rproj")), 1)
  expect_equal(nrow(x$suggestions), 1)
  expect_equal(nrow(x$paths), 1)

  proj_move_files(x$suggestions, execute = FALSE)
  expect_length(dir_ls(test_dir, type = "dir"), 0)
  proj_move_files(x$suggestions, execute = TRUE)
  expect_length(path_file(dir_ls(test_dir, type = "dir")), 1)

  # miceps
  dir <- test_path("project_miceps")
  test_dir <- sandbox(dir)

  expect_warning(x <- proj_test(test_dir), "randomness")

  expect_equal(nrow(x$packages), 5)
  expect_equal(nrow(dplyr::filter(x$files, ext != "Rproj")), 8)
  expect_equal(nrow(x$suggestions), 7)
  expect_equal(nrow(x$paths), 0)

  proj_move_files(x$suggestions, execute = FALSE)
  expect_length(dir_ls(test_dir, type = "dir"), 0)
  proj_move_files(x$suggestions, execute = TRUE)
  expect_length(path_file(dir_ls(test_dir, type = "dir")), 3)
})
