#[cfg(test)]
mod test_helpers {
    use starkludo::helpers::{get_start_points, get_markers};

    // *******************************************
    //          get_start_points
    // *******************************************

    #[test]
    fn test_get_start_points_returns_successfully() {
        let actual_result = get_start_points();
        let expected_result = array![0, 13, 26, 39];
        assert_eq!(actual_result, expected_result);
    }


    // *******************************************
    //          get_markers
    // *******************************************

    #[test]
    fn test_get_markers_returns_successfully() {
        let actual_result = get_markers();
        let expected_result = array![
            'r0',
            'r1',
            'r2',
            'r3',
            'g0',
            'g1',
            'g2',
            'g3',
            'y0',
            'y1',
            'y2',
            'y3',
            'b0',
            'b1',
            'b2',
            'b3',
        ];
        assert_eq!(actual_result, expected_result);
    }
}
