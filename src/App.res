open MaterialUi

module Main = {
  @react.component
  let make = () => {
    <Container>
      <Grid container=true>
        <Grid item=true>
          <Typography variant=#H3 gutterBottom=true> {"Monocle Web"->React.string} </Typography>
        </Grid>
      </Grid>
    </Container>
  }
}
