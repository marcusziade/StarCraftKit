import XCTest
@testable import StarCraftKit

final class PaginationInfoTests: XCTestCase {
    func testPaginationInfoCalculations() {
        let info = PaginationInfo(
            page: 3,
            perPage: 20,
            total: 95,
            links: NavigationLinks(from: nil)
        )
        
        XCTAssertEqual(info.totalPages, 5) // ceil(95/20) = 5
        XCTAssertTrue(info.hasNextPage) // page 3 < 5
        XCTAssertTrue(info.hasPreviousPage) // page 3 > 1
    }
    
    func testPaginationInfoEdgeCases() {
        let firstPage = PaginationInfo(
            page: 1,
            perPage: 50,
            total: 200,
            links: NavigationLinks(from: nil)
        )
        
        XCTAssertEqual(firstPage.totalPages, 4)
        XCTAssertTrue(firstPage.hasNextPage)
        XCTAssertFalse(firstPage.hasPreviousPage)
        
        let lastPage = PaginationInfo(
            page: 4,
            perPage: 50,
            total: 200,
            links: NavigationLinks(from: nil)
        )
        
        XCTAssertFalse(lastPage.hasNextPage)
        XCTAssertTrue(lastPage.hasPreviousPage)
    }
    
    func testNavigationLinksParser() {
        let linkHeader = """
        <https://api.pandascore.co/starcraft-2/players?page[number]=1>; rel="first", \
        <https://api.pandascore.co/starcraft-2/players?page[number]=2>; rel="prev", \
        <https://api.pandascore.co/starcraft-2/players?page[number]=4>; rel="next", \
        <https://api.pandascore.co/starcraft-2/players?page[number]=10>; rel="last"
        """
        
        let links = NavigationLinks(from: linkHeader)
        
        XCTAssertNotNil(links.first)
        XCTAssertNotNil(links.previous)
        XCTAssertNotNil(links.next)
        XCTAssertNotNil(links.last)
        
        XCTAssertTrue(links.first?.absoluteString.contains("page") ?? false)
        XCTAssertTrue(links.first?.absoluteString.contains("number") ?? false)
        XCTAssertTrue(links.first?.absoluteString.contains("=1") ?? false)
        
        XCTAssertTrue(links.last?.absoluteString.contains("page") ?? false)
        XCTAssertTrue(links.last?.absoluteString.contains("number") ?? false)
        XCTAssertTrue(links.last?.absoluteString.contains("=10") ?? false)
    }
    
    func testPaginationInfoFromHeaders() {
        let headers = [
            "X-Page": "2",
            "X-Per-Page": "25",
            "X-Total": "150",
            "Link": "<https://api.pandascore.co/starcraft-2/players?page[number]=1>; rel=\"first\""
        ]
        
        let info = PaginationInfo(from: headers)
        
        XCTAssertNotNil(info)
        XCTAssertEqual(info?.page, 2)
        XCTAssertEqual(info?.perPage, 25)
        XCTAssertEqual(info?.total, 150)
        XCTAssertEqual(info?.totalPages, 6)
    }
    
    func testPaginationInfoFromInvalidHeaders() {
        let invalidHeaders = [
            "X-Page": "invalid",
            "X-Per-Page": "25",
            "X-Total": "150"
        ]
        
        let info = PaginationInfo(from: invalidHeaders)
        XCTAssertNil(info)
    }
}