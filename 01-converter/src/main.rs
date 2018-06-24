use std::io::{self, Write};

fn main() {
    const F2C: u8 = 0;
    const C2F: u8 = 1;

    println!("Available conversions:");
    println!();
    println!("  {}: Fahrenheit => Celsius", F2C);
    println!("  {}: Celsius => Fahrenheit", C2F);
    println!();

    let mut conversion: u8;

    loop {
        print!("Your choice ? ");
        io::stdout().flush().unwrap();

        let mut input = String::new();

        io::stdin()
            .read_line(&mut input)
            .expect("Failed to read line");

        conversion = match input.trim().parse() {
            Ok(num) => num,
            Err(_) => {
                println!("Please enter a valid conversion.");
                continue;
            }
        };

        match conversion {
            F2C | C2F => break,
            _ => {
                println!("Please enter a valid conversion.");
                continue;
            }
        }
    }

    let temperature_input: String;
    let temperature: f32;

    loop {
        print!("Your temperature ? ");
        io::stdout().flush().unwrap();

        let mut input = String::new();

        io::stdin()
            .read_line(&mut input)
            .expect("Failed to read line");

        let input = input.trim();

        temperature = match input.parse() {
            Ok(num) => num,
            Err(_) => {
                println!("Please enter a valid temperature.");
                continue;
            }
        };

        temperature_input = input.to_string();

        break;
    }

    match conversion {
        F2C => println!(
            "{} Fahrenheit => {} Celsius",
            temperature_input,
            f2c(temperature)
        ),
        C2F => println!(
            "{} Celsius => {} Fahrenheit",
            temperature_input,
            c2f(temperature)
        ),
        _ => println!("Unknown conversion"),
    }
}

fn round_2(num: f32) -> f32 {
    (num * 100.0).round() / 100.0
}

fn f2c(temp: f32) -> f32 {
    round_2((temp - 32.0) / 1.8)
}

fn c2f(temp: f32) -> f32 {
    round_2((temp * 1.8) + 32.0)
}
