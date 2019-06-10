frost_control_args <- function(input_args, func) {

  if (func == "get_observations") {

    input_args_ctrl <-
      list(
        sources               = list(type = "character"),
        referencetime         = list(type = "character", max_length = 1),
        elements              = list(type = "character"),
        maxage                = list(type = "character", max_length = 1),
        limit                 = list(type = c("character", "double", "integer"), max_length = 1),
        timeoffsets           = list(type = "character"),
        timeresolutions       = list(type = "character"),
        timeseriesids         = list(type = c("double", "integer")),
        performancecategories = list(type = "character"),
        exposurecategories    = list(type = c("double", "integer")),
        qualities             = list(type = c("double", "integer")),
        levels                = list(type = c("double", "integer")),
        includeextra          = list(type = c("double", "integer")),
        fields                = list(type = "character")
      )

  } else if (func == "get_sources") {

    input_args_ctrl <-
      list(
        ids             = list(type = "character"),
        types           = list(type = "character", max_length = 1),
        geometry        = list(type = "character", max_length = 1),
        nearestmaxcount = list(type = c("integer", "double"), max_length = 1),
        validtime       = list(type = "character", max_length = 1),
        name            = list(type = "character", max_length = 1),
        country         = list(type = "character", max_length = 1),
        county          = list(type = "character", max_length = 1),
        municipality    = list(type = "character", max_length = 1),
        wmoid           = list(type = "character", max_length = 1),
        stationholder   = list(type = "character", max_length = 1),
        externalids     = list(type = "character", max_length = 1),
        icaocode        = list(type = "character", max_length = 1),
        shipcode        = list(type = "character", max_length = 1),
        wigosid         = list(type = "character", max_length = 1),
        fields          = list(type = "character")
      )

  } else if (func == "get_locations") {

    input_args_ctrl <-
      list(
        names    = list(type = "character"),
        geometry = list(type = "character", max_length = 1),
        fields   = list(type = "character")
      )

  } else if (func == "get_elements") {

    input_args_ctrl <-
      list(
        ids               = list(type = "character"),
        names             = list(type = "character"),
        descriptions      = list(type = "character"),
        units             = list(type = "character"),
        codeTables        = list(type = "character"),
        statuses          = list(type = "character"),
        calculationMethod = list(type = "character"),
        categories        = list(type = "character"),
        timeOffsets       = list(type = "character"),
        sensorLevels      = list(type = "character"),
        oldElementCodes   = list(type = "character"),
        oldUnits          = list(type = "character"),
        cfStandardNames   = list(type = "character"),
        cfCellMethods     = list(type = "character"),
        cfUnits           = list(type = "character"),
        cfVersions        = list(type = "character"),
        fields            = list(type = "character"),
        lang              = list(type = "character", max_length = 1)
      )

  } else if (func == "get_available_timeseries") {

    input_args_ctrl <-
      list(
        sources               = list(type = "character"),
        referencetime         = list(type = "character", max_length = 1),
        elements              = list(type = "character"),
        timeoffsets           = list(type = "character"),
        timeresolutions       = list(type = "character"),
        timeseriesids         = list(type = c("double", "integer")),
        performancecategories = list(type = "character"),
        exposurecategories    = list(type = c("double", "integer")),
        levels                = list(type = c("double", "integer")),
        levelTypes            = list(type = c("character")),
        levelUnits            = list(type = "character"),
        includeextra          = list(type = c("double", "integer")),
        fields                = list(type = "character")
      )

  } else if (func == "get_available_qualitycodes") {

    input_args_ctrl <-
      list(
        fields = list(type = "character"),
        lang   = list(type = "character", max_length = 1)
      )

  } else if (func == "get_element_codetables") {

    input_args_ctrl <-
      list(
        ids    = list(type = "character"),
        fields = list(type = "character"),
        lang   = list(type = "character", max_length = 1)
      )

  } else {

    stop("The package developer has made an error, and the function cannot ",
         "continue with your requested operation.",
         call. = FALSE)

  }

  for (i in 1:length(input_args)) {

    if (!is.null(input_args[[i]])) {

      input_type          <- typeof(input_args[[i]])
      input_type_expected <- typeof(input_args_ctrl[[i]][["type"]])

      if(input_type != input_type_expected) {

        stop("`", names(input_args[i]), "`", " must be of type ",
             "`", input_type_expected, "`. ",
             "You have submitted ", "`", names(input_args[i]), "`",
             " as a `", input_type, "` data type.",
             call. = FALSE)

      } else {

        next

      }

    } else {

      next

    }

  }

  for (i in 1:length(input_args)) {

    if ("max_length" %in% names(input_args_ctrl[[i]])) {

      input_length     <- length(input_args[[i]])
      input_length_max <- input_args_ctrl[[i]][["max_length"]]

      if (input_length > input_length_max) {

        stop("`", names(input_args[i]), "`", " is of length ", input_length, ", ",
             " while it must have a length less than or equal to ",
             input_length_max, ".",
             call. = FALSE)

      } else {

        next

      }

    } else {

      next

    }

  }

}
