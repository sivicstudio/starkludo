<<<<<<< HEAD
declare module 'react-simple-flex-grid' {
    export const Row: React.ComponentType<any>;
    export const Col: React.ComponentType<any>;
}
=======
declare module "react-simple-flex-grid" {
  import { HTMLProps, PureComponent } from "react";

  type JustifyContent =
    | "start"
    | "end"
    | "center"
    | "space-around"
    | "space-between";

  type AlignItems = "top " | "middle " | "bottom";

  type Breakpoint = {
    span?: number;
    offset?: number;
  };

  export interface IRowProps {
    gutter?: number;
    justify?: JustifyContent;
    align?: AlignItems;
  }

  interface IColProps {
    span?: number;
    offset?: number;
    order?: number;
    xs?: number | Breakpoint;
    sm?: number | Breakpoint;
    md?: number | Breakpoint;
    lg?: number | Breakpoint;
    xl?: number | Breakpoint;
  }

  export class Row extends PureComponent<
    IRowProps & HTMLProps<HTMLDivElement>
  > {}

  export class Col extends PureComponent<
    IColProps & HTMLProps<HTMLDivElement>
  > {}
}
>>>>>>> c43c6f1d481754a137db14df3d2d25dbafa13db0
