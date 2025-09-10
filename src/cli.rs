use clap::Parser;

use crate::LogLevel;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
pub(crate) struct Args {
    #[arg(default_value = "", value_name = "NAME", help = "Name of the project to update. The name should form 'owner/repo'.")]
    pub(crate) names: Vec<String>,

    #[arg(short, long, default_value = "warn", help = "Set the logging level.")]
    pub(crate) level: LogLevel,
}

