use std::collections::HashMap;
use std::fs::File;
use std::io;
use std::io::BufRead;
use std::vec::Vec;

fn read_lists(path: &str) -> (Vec<i32>, Vec<i32>) {
    let file = File::open(path).unwrap();

    io::BufReader::new(file)
        .lines()
        .map(|line| line.unwrap())
        .map(|line| {
            let splits = line.split_once("   ").unwrap();

            (
                splits.0.parse::<i32>().unwrap(),
                splits.1.parse::<i32>().unwrap(),
            )
        })
        .unzip()
}

fn main() {
    let (list_one, list_two) = read_lists("resources/input.file");

    part_one((list_one.clone(), list_two.clone()));
    part_two((list_one.clone(), list_two.clone()));
}

fn part_one(lists: (Vec<i32>, Vec<i32>)) {
    let (mut list_one, mut list_two) = lists;

    list_one.sort();
    list_two.sort();

    let sum: i32 = list_one
        .iter()
        .zip(list_two.iter())
        .map(|(left, right)| (left - right).abs())
        .sum();

    println!("{}", sum);
}

fn part_two(lists: (Vec<i32>, Vec<i32>)) {
    let (list_one, list_two) = lists;

    let hashmap = list_two.into_iter().fold(HashMap::new(), |mut acc, value| {
        *acc.entry(value).or_insert(0) += 1;
        acc
    });

    let sum: i32 = list_one
        .iter()
        .map(|value| value * hashmap.get(value).unwrap_or(&0))
        .sum();

    println!("{}", sum);
}
