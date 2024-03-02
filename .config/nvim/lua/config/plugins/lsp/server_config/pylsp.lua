return {
    settings = {
        pylsp = {
            plugins = {
                autopep8 = { enabled = false },
                jedi_completion = {
                    enabled = true,
                    fuzzy = true,
                    eager = true,
                    cache_for = {
                        "pandas",
                        "numpy",
                        "tensorflow",
                        "matplotlib",
                        "requests",
                        "plotly",
                    },
                },
                mccabe = { enabled = false },
                pycodestyle = { enabled = false },
                pydocstyle = { enabled = false },
                pyflakes = { enabled = false },
                pylint = { enabled = false },
                rope_completion = { enabled = false },
                yapf = { enabled = false },
            },
        },
    },
}
