// Copyright 2020, OpenTelemetry Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

/// No-op implementation of the SpanBuilder
class PropagatedSpanBuilder: SpanBuilder {
    private var tracer: Tracer
    private var isRootSpan: Bool = false
    private var spanContext: SpanContext?

    init(tracer: Tracer, spanName: String) {
        self.tracer = tracer
    }

    @discardableResult public func startSpan() -> Span {
        if spanContext == nil, !isRootSpan {
            spanContext = tracer.activeSpan?.context
        }
        if spanContext != nil && spanContext != SpanContext.invalid {
            return PropagatedSpan(context: spanContext!, kind: .client)
        } else {
            return PropagatedSpan(context: SpanContext.create(traceId: TraceId.random(),
                                                              spanId: SpanId.random(),
                                                              traceFlags: TraceFlags(),
                                                              traceState: TraceState()))
        }
    }

    @discardableResult public func setParent(_ parent: Span) -> Self {
        spanContext = parent.context
        return self
    }

    @discardableResult public func setParent(_ parent: SpanContext) -> Self {
        spanContext = parent
        return self
    }

    @discardableResult public func setNoParent() -> Self {
        isRootSpan = true
        return self
    }

    @discardableResult public func addLink(spanContext: SpanContext) -> Self {
        return self
    }

    @discardableResult public func addLink(spanContext: SpanContext, attributes: [String: AttributeValue]) -> Self {
        return self
    }

    @discardableResult public func setSpanKind(spanKind: SpanKind) -> Self {
        return self
    }

    @discardableResult public func setStartTime(time: Date) -> Self {
        return self
    }

    public func setAttribute(key: String, value: AttributeValue) -> Self {
        return self
    }
}
