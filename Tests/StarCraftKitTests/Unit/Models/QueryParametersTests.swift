import XCTest
@testable import StarCraftKit

final class QueryParametersTests: XCTestCase {
    func testPaginationParameters() {
        let pagination = PaginationParameters(page: 5, size: 150)
        XCTAssertEqual(pagination.page, 5)
        XCTAssertEqual(pagination.size, 100) // Should be clamped to max 100
        
        let smallPagination = PaginationParameters(page: 0, size: 0)
        XCTAssertEqual(smallPagination.page, 1) // Should be at least 1
        XCTAssertEqual(smallPagination.size, 1) // Should be at least 1
    }
    
    func testSortParameter() {
        let ascSort = SortParameter(field: "name", direction: .ascending)
        XCTAssertEqual(ascSort.toString(), "name")
        
        let descSort = SortParameter(field: "created_at", direction: .descending)
        XCTAssertEqual(descSort.toString(), "-created_at")
    }
    
    func testRangeParameter() {
        let fullRange = RangeParameter(min: 10, max: 100)
        XCTAssertEqual(fullRange.toString(), "10.0,100.0")
        
        let minOnly = RangeParameter(min: 50)
        XCTAssertEqual(minOnly.toString(), "50.0,")
        
        let maxOnly = RangeParameter(max: 200)
        XCTAssertEqual(maxOnly.toString(), ",200.0")
        
        let empty = RangeParameter()
        XCTAssertEqual(empty.toString(), "")
    }
    
    func testQueryParametersBuilder() {
        let params = QueryParameters.Builder()
            .withPagination(page: 2, size: 25)
            .withSort("name", direction: .ascending)
            .withSort("age", direction: .descending)
            .withFilter("status", value: "active")
            .withSearch("name", value: "John")
            .withRange("score", min: 80, max: 100)
            .build()
        
        let dict = params.toDictionary()
        
        XCTAssertEqual(dict["page[number]"] as? Int, 2)
        XCTAssertEqual(dict["page[size]"] as? Int, 25)
        XCTAssertEqual(dict["sort"] as? String, "name,-age")
        XCTAssertEqual(dict["filter[status]"] as? String, "active")
        XCTAssertEqual(dict["search[name]"] as? String, "John")
        XCTAssertEqual(dict["range[score]"] as? String, "80.0,100.0")
    }
    
    func testQueryParametersToDictionary() {
        let params = QueryParameters(
            pagination: PaginationParameters(page: 1, size: 50),
            sort: [SortParameter(field: "date", direction: .descending)],
            filters: ["team_id": 123, "active": true],
            search: ["player": "Serral"],
            ranges: ["rating": RangeParameter(min: 2000)]
        )
        
        let dict = params.toDictionary()
        
        XCTAssertEqual(dict["page[number]"] as? Int, 1)
        XCTAssertEqual(dict["page[size]"] as? Int, 50)
        XCTAssertEqual(dict["sort"] as? String, "-date")
        XCTAssertEqual(dict["filter[team_id]"] as? Int, 123)
        XCTAssertEqual(dict["filter[active]"] as? Bool, true)
        XCTAssertEqual(dict["search[player]"] as? String, "Serral")
        XCTAssertEqual(dict["range[rating]"] as? String, "2000.0,")
    }
}