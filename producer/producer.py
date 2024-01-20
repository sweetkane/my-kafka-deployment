from datasource import IDatasource

class Producer:
    def __init__(self, datasource: IDatasource) -> None:
        self.datasource = datasource
