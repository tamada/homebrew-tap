use anyhow::Result;
use clap::{Parser, ValueEnum};

use crate::LogLevel;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
pub(crate) struct Args {
    #[arg(index=1, value_name = "NAME", help = "Name of the project to update. The name should form 'owner/repo'.")]
    pub(crate) names: Vec<String>,

    #[arg(short, long, default_value = "warn", help = "Set the logging level.")]
    pub(crate) level: LogLevel,

    #[clap(flatten)]
    pub(crate) config: Config,
}

impl Args {
    pub(crate) fn init(self) -> Result<(Vec<String>, Config)> {
        init_logger(self.level)?;
        Ok((self.names, self.config))
    }
}

#[derive(Parser, Debug)]
pub(crate) struct Config {
    #[arg(short = 'D', long, default_value = "false", help = "Run as dry run mode, and output the recipes to the standard output.")]
    pub(crate) dry_run: bool,

    #[arg(long, default_value = "all", requires = "dry_run", help = "In dry run mode, specify which part to show.", value_enum, value_delimiter = ',')]
    pub(crate) show_mode: Vec<ShowMode>,

    #[arg(long, default_value_t = false, help = "Disable update the formula.", conflicts_with = "force_update")]
    pub(crate) disable_update: bool,

    #[arg(long, default_value_t = false, help = "Force update the formula even if the target project's ignore-fetch-release is true.")]
    pub(crate) force_update: bool,

    #[arg(long, default_value_t = false, help = "Do not update the recipe of the given formula and README file.")]
    pub(crate) keep_recipe: bool,
}

impl Config {
    pub(crate) fn is_show_target(&self, mode: ShowMode) -> bool {
        self.show_mode.contains(&ShowMode::All) || self.show_mode.contains(&mode)
    }
}

#[derive(Parser, Debug, ValueEnum, Clone, PartialEq)]
pub(crate) enum ShowMode {
    All,
    Recipe,
    Readme,
    ProjectJson,
}

fn init_logger(level: LogLevel) -> Result<()> {
    let log_level = match level {
        LogLevel::Trace => log::LevelFilter::Trace,
        LogLevel::Debug => log::LevelFilter::Debug,
        LogLevel::Info => log::LevelFilter::Info,
        LogLevel::Warn => log::LevelFilter::Warn,
        LogLevel::Error => log::LevelFilter::Error,
    };

    let mut builder = env_logger::Builder::new();
    builder.filter(None, log_level);
    builder.init();
    Ok(())
}
