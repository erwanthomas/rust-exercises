use std::io::{self, Write};

fn main() {
    const F2C: u8 = 0;
    const C2F: u8 = 1;

    println!("Available conversions:");
    println!();
    println!("  {}: Farenheit => Celsius", F2C);
    println!("  {}: Celsius => Farenheit", C2F);
    println!();

    let mut conversion;

    loop {
        print!("Your choice ? ");
        io::stdout().flush().unwrap();

        let mut input = String::new();

        io::stdin().read_line(&mut input).expect("Failed to read line");

        conversion =
            match input.trim().parse::<u8>() {
                Ok(num) => num,
                Err(error) => {
                    println!("Error: {}", error);
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

    let temperature;

    loop {
        print!("Your temperature ? ");
        io::stdout().flush().unwrap();

        let mut input = String::new();

        io::stdin().read_line(&mut input).expect("Failed to read line");

        temperature =
            match input.trim().parse::<f32>() {
                Ok(num) => num,
                Err(error) => {
                    println!("Error: {}", error);
                    println!("Please enter a valid number.");
                    continue;
                }
            };

        break;
    }

    println!();

    match conversion {
        F2C => println!("{} Fahrenheit => {} Celsius", temperature, f2c(temperature)),
        C2F => println!("{} Celsius => {} Fahrenheit", temperature, c2f(temperature)),
        _ => println!("Unknown conversion"),
    }
}

fn f2c(temp: f32) -> f32 {
    (temp - 32.0) / 1.8
}

fn c2f(temp: f32) -> f32 {
    temp * 1.8 + 32.0
}
