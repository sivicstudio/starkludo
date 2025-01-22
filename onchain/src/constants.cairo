use starknet::{ContractAddress, contract_address_const};

#[derive(Serde, Copy, Drop, Introspect, PartialEq)]
pub enum TileNode {
    R1,
    R2,
    R3,
    R4,
    R5,
    R6,
    G1,
    G2,
    G3,
    G4,
    G5,
    G6,
    Y1,
    Y2,
    Y3,
    Y4,
    Y5,
    Y6,
    B1,
    B2,
    B3,
    B4,
    B5,
    B6,
    R01,
    R02,
    R03,
    R04,
    G01,
    G02,
    G03,
    G04,
    Y01,
    Y02,
    Y03,
    Y04,
    B01,
    B02,
    B03,
    B04,
}

fn get_safe_positions() -> Array<u32> {
    array![
        1, 9, 14, 22, 27, 35, 40, 48, 1001, 1002, 1003, 1004, 1005,
        2001, 2002, 2003, 2004, 2005, 3001, 3002, 3003, 3004, 3005,
        4001, 4002, 4003, 4004, 4005
    ]
}

fn get_markers() -> Array<felt252> {
    array![
        'r0', 'r1', 'r2', 'r3',
        'g0', 'g1', 'g2', 'g3',
        'y0', 'y1', 'y2', 'y3',
        'b0', 'b1', 'b2', 'b3'
    ]
}

fn find_index(value: felt252, a: Array<felt252>) -> usize {
    let mut i = 0;
    loop {
        if (i >= a.len()) {
            break 0;
        } else if (a.at(i) == @value) {
            break i;
        }
        i += 1;
    }
}

fn get_start_points() -> Array<u32> {
    array![0, 13, 26, 39]
}

fn board_to_pos(arr: Array<u32>) -> Array<u32> {
    let mut new_arr: Array<u32> = ArrayTrait::new();
    let mut i: u32 = 0;

    loop {
        if i >= arr.len() {
            break;
        }

        let val = *arr.at(i);
        let color: u32 = i / 4;

        let new_val = if val > 52 {
            51 + (val % 1000)
        } else if val == 0 {
            0

        } else {
            let diff = if val >= *get_start_points().at(color) {
                val - *get_start_points().at(color)
            } else {
                val + 52 - *get_start_points().at(color)
            };

            if diff < 1 {
                diff + 52
            } else {
                diff
            }
        };

        new_arr.append(new_val);
        i += 1;
    };

    new_arr
}

fn pos_to_board(arr: Array<u32>) -> Array<u32> {
    let mut new_arr: Array<u32> = ArrayTrait::new();
    let mut i: u32 = 0;

    loop {
        if i >= arr.len() {
            break;
        }

        let val = *arr.at(i);
        let color: u32 = i / 4;

        let new_val = if val > 51 {
            (color + 1) * 1000 + (val % 50) - 1
        } else if val == 0 {
            0
        } else {
            let a = (*get_start_points().at(color) + val) % 52;
            if a == 0 {
                52
            } else {
                a
            }
        };

        new_arr.append(new_val);
        i += 1;
    };

    new_arr
}

fn zero_address() -> ContractAddress {
    contract_address_const::<0x0>()
}

fn contains(array: Array<u32>, value: u32) -> bool {
    let mut found = false;
        for item in array {
            if item == value {
                found = true;
                break;
            }
        };
    return found;

}

fn get_cap_colors() -> Array<felt252> {
    array!['R', 'G', 'Y', 'B']
}

fn pos_reducer(data: Array<u32>, players_length: u32) -> Array<felt252> {
    let mut game: Array<felt252> = ArrayTrait::new();
    let cap_colors = get_cap_colors();

    let mut i: u32 = 0;
    loop {
        if i >= data.len() {
            break;
        }
        if i < players_length * 4 {
            let d = *data.at(i);
            let color = *cap_colors.at((i / 4).try_into().unwrap());

            let value = if d == 0 {
                // Format: color + "0" + (i % 4 + 1)
                color * 100 + (i % 4 + 1).into()
            } else if d > 1000 {
                 // Format: color + (d % 1000)
                color * 1000 + (d % 1000).into()
            } else {
                d.into()
            };

            game.append(value);
        }
        i += 1;
    };

    game
}
